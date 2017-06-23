(function() {
  BenchPrep.SearchOptions = Backbone.Model.extend({
    defaults: {
      keyword: "",
      currentPage: 1,
      pageSize: 15
    },
    initialize: function(options) {
      this.collection = options.collection;
      this.filteredFields = options.filteredFields;
      var initialPage = this.getPaginatedItems(
        this.collection.models,
        this.get("currentPage")
      );
      this.filtered = new Backbone.Collection(initialPage);
      this.on("change:currentPage", this.changePage);
    },
    filter: function() {
      this.attributes["currentPage"] = 1;
      var keyword = this.get("keyword").trim();
      var models = [];

      if (keyword === "") {
        models = this.collection.models;
      } else {
        var self = this;
        models = this.collection.filter(function(model) {
          return _.some(_.values(model.pick(self.filteredFields)), function(
            value
          ) {
            return ~value.toLowerCase().indexOf(keyword);
          });
        });
      }

      var pageData = this.getPaginatedItems(models, this.get("currentPage"));
      this.filtered.reset(pageData);
    },
    changePage: function() {
      var pageData = this.getPaginatedItems(
        this.pagingInfo.totalCollection,
        this.get("currentPage")
      );
      this.filtered.reset(pageData);
    },
    getPaginatedItems: function(items, page) {
      var page = page || 1,
        pageSize = this.get("pageSize"),
        offset = (page - 1) * pageSize,
        paginatedItems = _.rest(items, offset).slice(0, pageSize);

      this.pagingInfo = {
        page: page,
        pageSize: pageSize,
        totalCollection: items,
        pageCount: Math.ceil(items.length / pageSize),
        data: paginatedItems
      };

      return paginatedItems;
    }
  });

  BenchPrep.SearchOptionView = BenchPrep.View.extend({
    template: "#search-form-template",
    events: {
      "submit form": "onFormSubmit",
      "change #search-bar": function(e) {
        this.model.set("keyword", e.currentTarget.value);
      }
    },
    onFormSubmit: function(e) {
      e.preventDefault();
      this.model.filter();
    }
  });

  BenchPrep.PageItem = Backbone.Model.extend({
    defaults: {
      pageNumber: 1
    }
  });

  BenchPrep.PageItemView = BenchPrep.View.extend({
    template: "#page-item-template",
    tagName: "li",
    className: function() {
      return this.model.get("selected") ? "active" : "";
    },
    events: {
      "click a": "onPageClicked"
    },
    onPageClicked: function(e) {
      e.preventDefault();
      $("html, body").animate({ scrollTop: 0 }, "slow");
      this.$el.trigger("BenchPrep:pageClicked", this);
    }
  });

  BenchPrep.PaginationListView = Backbone.View.extend({
    initialize: function(options) {
      this.listenTo(this.model.filtered, "reset", this.render);

      if (options.onPageSelected) {
        this.onPageSelected = options.onPageSelected;
      }
    },
    tagName: "ul",
    className: "pagination",
    events: {
      "BenchPrep:pageClicked": "onPageSelected"
    },
    render: function() {
      var els = [];

      for (var i = 0; i < this.model.pagingInfo.pageCount; i++) {
        var pageNumber = i + 1;
        var paginationView = new BenchPrep.PageItemView({
          model: new BenchPrep.PageItem({
            pageNumber: pageNumber,
            selected: this.model.pagingInfo.page == pageNumber
          })
        });
        els.push(paginationView.render().el);
      }

      this.$el.html(els);
      return this;
    }
  });
})();
