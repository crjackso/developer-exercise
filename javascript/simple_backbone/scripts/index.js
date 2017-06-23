(function() {
  BenchPrep = {
    init: function() {
      var quotes = new BenchPrep.QuoteCollection();

      quotes.fetch({
        success: function(collection) {
          var searchOptions = new BenchPrep.SearchOptions({
            collection: collection,
            filteredFields: ["quote"]
          });
          var quotesLayout = new BenchPrep.QuotesLayoutView({
            model: searchOptions
          });

          $("#quotes-layout").append(quotesLayout.render().el);
        }
      });
    }
  };
})();
