const MongoClient = require('mongodb').MongoClient;
var dbConfig = require('../config/dbConfig');
var fsPromises = require('fs').promises;
var log = require('../log');

class EventData {

    constructor() {    
        this.database = null;
        this.collection = null;
      }

    async init() {
        log.Logger.debug('Connecting to MongoDB...');                
        await this.ensureCollection();
        log.Logger.debug('Collection: %s, in database: %s is ready', dbConfig.database.collection, dbConfig.database.name);
        await this.seed();
    }

    async seed() {
        var documentCount = await this.collection.estimatedDocumentCount();        
        if (documentCount == 0) {
            log.Logger.debug('Seeding default data...');
            var events = [
            {
                id: 'dcus20',
                title: 'DockerCon',
                detail: 'The #1 container conference for the industry',
                date: '2020-06-15'
            }, 
            {
                id: 'pslive20',
                title: 'Pluralsight Live',
                detail: 'The ultimate tech skills conference',
                date: '2020-10-13'
            }];
            await this.collection.insertMany(events);
            log.Logger.debug('Data seeded');
        }
        else {
            log.Logger.debug('Data exists, not seeding');
        }
    }    

    async findAll() {
        await this.ensureCollection();
        const results = await this.collection.find({}).toArray();
        log.Logger.debug('findAll() returning: %n events', results.length);        
        return results;
    }

    async create(event) {
        this.ensureCollection();
        event.id = this.generateId();
        await this.collection.insertOne(event);
        log.Logger.debug('Created event with id: %s', event.id);
        return event.id;
    }

    async delete(eventId) {
        await this.ensureCollection();
        await this.collection.findOneAndDelete({id:eventId});
        log.Logger.debug('Deleted event with id: %s', eventId);        
    }

    generateId() {
        return 'xxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
        });
    }

    async ensureCollection() {
        if (this.collection == null) {
            var connectionString = await fsPromises.readFile("/app/config/mongo-connection-string", "utf8");
            const client = new MongoClient(connectionString, { useNewUrlParser: true });
            await client.connect();
            this.database = client.db(dbConfig.database.name);
            this.collection = this.database.collection(dbConfig.database.collection);
        }
    }
}

module.exports = EventData