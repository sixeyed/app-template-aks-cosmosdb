new Vue({
  el: '#events',

  data: {
    event: { title: '', detail: '', date: '' },
    events: []
  },

  ready: function () {
    this.fetchEvents();
  },

  methods: {

    fetchEvents: function () {
      var events = [];
      this.$http.get('/api/events')
        .success(function (events) {
          this.$set('events', events);
          console.log(events);
        })
        .error(function (err) {
          console.log(err);
        });
    },

    addEvent: function () {
      if (this.event.title.trim()) {
        this.$http.post('/api/events', this.event)
          .success(function (res) {
            this.event.id = res.eventId;
            this.events.push(this.event);
            console.log('Event added!');
          })
          .error(function (err) {
            console.log(err);
          });
      }
    },

    deleteEvent: function (id) {     
        this.$http.delete('api/events/' + id)
          .success(function (res) {
            console.log(res);            
            var event = this.events.find(x => x.id === id);
            var index = this.events.indexOf(event);
            this.events.splice(index, 1);
          })
          .error(function (err) {
            console.log(err);
          });
    }
  }
});