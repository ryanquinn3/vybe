
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.afterSave("Rating", function(request) {
  var query = new Parse.Query("Bar");
  query.get(request.object.get("bar").id,{
  	success: function(bar)
  	{
      var currentRating = request.object;

      var newCrowdAvg = (bar.get("avgCrowd") + currentRating.get("crowd"))/2;
      var newAtmAvg = (bar.get("avgAtmosphere") + currentRating.get("atmosphere"))/2;
      var newRatioAvg = (bar.get("avgRatio") + currentRating.get("ratio"))/2;
      var newCoverAvg = (bar.get("avgCover") + currentRating.get("cover"))/2;
      var newWaitAvg = (bar.get("avgWait") + currentRating.get("wait"))/2;

      bar.set("avgAtmosphere",newAtmAvg);
      bar.set("avgCover",newCoverAvg);
      bar.set("avgRatio",newRatioAvg);
      bar.set("avgWait",newWaitAvg);
      bar.set("avgCrowd",newCrowdAvg);
      bar.increment("numRatings");
      bar.save();
  	},
  	error: function(error)
  	{
  		console.error("Got an error "+error.code+" : "+error.message);
  	}
  });
});
