const EventData = require('./eventData');
var log = require('../log');

const eventData = new EventData();

exports.events = function (req, res) {
  log.Logger.info('Loading events...');  
  eventData
    .findAll()
    .then(events => {
        log.Logger.debug('Fetched events, count: ' + events.length);
        res.json(events);
    })
    .catch(err => {
      log.Logger.error('** Fetch failed: ', err);
    });
};

exports.event = function (req, res) {
  log.Logger.debug('Handling event call, method: ' + req.method + ', event ID: ' + req.params.eventId)
  switch(req.method) {
    case "DELETE":
      eventData
      .delete(req.params.eventId)
      .then(function() {
        log.Logger.info('Deleted event with id: ' + req.params.eventId)
        res.status(200).end();
      });
      break
    case "POST":
      eventData
        .create({
          title: req.body.title,
          detail: req.body.detail,
          date: req.body.date
        })
        .then(function(eventId) {
          log.Logger.info('Created event with title: ' + req.body.title)
          var response = { eventId: eventId };
          res.send(JSON.stringify(response));
          res.status(201).end();
        });
      break
  }
};