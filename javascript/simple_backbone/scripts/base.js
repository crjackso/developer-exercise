(function() {
  BenchPrep.View = Backbone.View.extend({
    render: function() {
      var source = $(this.template).html();
      var data = {};
      if (this.model) data = this.model.toJSON();
      var compiled = _.template(source)(data);
      this.$el.html(compiled);
      return this;
    }
  });

  BenchPrep.ListView = Backbone.View.extend({
    initialize: function() {
      this.listenTo(this.collection, "reset", this.render);
    },

    render: function() {
      var self = this;
      var els = [];
      this.$el.empty();
      this.collection.each(function(item) {
        var itemView = new self.ItemView({ model: item });
        els.push(itemView.render().el);
      });
      this.$el.append(els);
      return this;
    }
  });

  BenchPrep.Layout = Backbone.View.extend({
    render: function() {
      this.$el.empty();

      var templateSource = $(this.template).html();
      this.$el.append(_.template(templateSource));

      var self = this;

      _.each(self.regions, function(selector, name) {
        self[name] = self.$(selector);
      });

      if (self.layoutReady) self.layoutReady();

      return self;
    }
  });
})();
