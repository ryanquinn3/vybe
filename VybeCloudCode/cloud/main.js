
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

//Try given GeoPoint
//Parse.Cloud.define()

Parse.Cloud.define("getData",function(request,response){
  var barQuery = new Parse.Query("Bar");
  var data = [];
  barQuery.find({
    success: function(results){
      for(var i = 0; i < results.length;i++){
        var bar = results[i];
        var barEntry = {'bar':bar};
        getAllRatings(barEntry,data,response,results.length);
      }
    },
    error: function(){
      response.error("Failed to pull bars");
    }
  });
});

function getAllRatings(barData,data,response,max){
  var ratingQuery = new Parse.Query("Rating");
  ratingQuery.equalTo("bar",barData['bar']);
  ratingQuery.include("hashtag");
  ratingQuery.find({
    success:function(ratings){
      var ratingArray = [];
      var ratingData;
      for(var i = 0; i < ratings.length; i++){
        var rating  = ratings[i];
        var dateCreated = new Date(rating.createdAt);
        var now = new Date();

        if( Math.abs(now-dateCreated)/36e5 < 12 )
        {
            ratingData = {
            "hashtag": rating.get("hashtag").get("name"),
            "hashtagId": rating.get("hashtag").id,
            "user": rating.get("user").id,
            "score": rating.get("score"),
            "createdAt": rating.createdAt
            };
            ratingArray.push(ratingData);
        }
      }
      barData["ratings"] = ratingArray;
      data.push(barData);
      if(data.length === max){
        response.success(data);
      }
    },
    error:function(){

    }
  });
}


Parse.Cloud.define("getRatings",function(request,response){
  var query = new Parse.Query("Rating");
  var Bar = Parse.Object.extend("Bar");
  var bar = new Bar();
  bar.id = request.params.bar;
  query.equalTo("bar",bar);
  query.include("hashtag");
  query.find({
    success:function(ratings){
      var ratingsArray = [];
      var ratingData;
      for(var i = 0; i < ratings.length; i ++){
        var rating  = ratings[i];

        var dateCreated = new Date(rating.createdAt);
        var now = new Date();

        if( Math.abs(now-dateCreated)/36e5 < 12 )
        {
            ratingData = {
              "hashtag": rating.get("hashtag").get("name"),
              "hashtagId": rating.get("hashtag").id,
              "user": rating.get("user").id,
              "score": rating.get("score"),
              "createdAt": rating.createdAt
            };
            ratingsArray.push(ratingData);
       }
      }
      response.success(ratingsArray);
    },
    error:function(){
      response.error("Bar not found");
    }
  });
});


Parse.Cloud.define("getTopHashtags",function(request,response){
  var query = new Parse.Query("Rating");
  var Bar = Parse.Object.extend("Bar");
  var bar = new Bar();
  bar.id = request.params.bar;
  query.equalTo("bar",bar);
  query.include("hashtag");
  query.find({
    success:function(ratings){
      var ratingsMap = {};
      for(var i = 0; i < ratings.length; i++)
      {
        var rating = ratings[i];
        var htName = rating.get("hashtag").get("name");
        if(ratingsMap[htName] === undefined)
        {
            ratingsMap[htName] = rating.get("score");
        }else{
          ratingsMap[htName] += rating.get("score");
        }
      }
      var ratingsArray = [];
      var tempObj;
      for(var key in ratingsMap)
      {
          var score = ratingsMap[key];
          tempObj = {
            "hashtag":key,
            "score":score
          };
          ratingsArray.push(tempObj);
      }
      ratingsArray.sort(function(a,b)
      {
        return b.score-a.score;
      });

      response.success(ratingsArray.slice(0,3));



    },
    error:function(){
      response.error("Bar not found");
    }
  });



});





