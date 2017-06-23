(function() {
  BenchPrep.Quote = Backbone.Model.extend({});

  BenchPrep.QuoteView = BenchPrep.View.extend({
    tagName: "tr",
    template: "#quote-template"
  });

  BenchPrep.QuoteListView = BenchPrep.ListView.extend({
    tagName: "tbody",
    ItemView: BenchPrep.QuoteView
  });

  BenchPrep.QuoteCollection = Backbone.Collection.extend({
    model: BenchPrep.Quote,
    url: "https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json"
  });

  BenchPrep.QuotesLayoutView = BenchPrep.Layout.extend({
    template: "#quote-list-template",
    regions: {
      quoteListRegion: "#quotes",
      searchOptionsRegion: "#search-options",
      paginationRegion: "#paginator"
    },
    layoutReady: function() {
      var self = this;
      var quoteListView = new BenchPrep.QuoteListView({
        collection: this.model.filtered
      });

      var searchOptionsView = new BenchPrep.SearchOptionView({
        model: this.model
      });

      var paginatorView = new BenchPrep.PaginationListView({
        model: this.model,
        onPageSelected: function(e, pageModel) {
          if (!pageModel || !pageModel.model) {
            return;
          }
          self.model.set("currentPage", pageModel.model.get("pageNumber") || 0);
        }
      });

      this.quoteListRegion.append(quoteListView.render().el);
      this.searchOptionsRegion.append(searchOptionsView.render().el);
      this.paginationRegion.append(paginatorView.render().el);
    }
  });
})();
