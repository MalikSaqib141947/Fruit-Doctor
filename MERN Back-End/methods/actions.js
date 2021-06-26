var users = require('../models/user')
var thread = require('../models/discussionThread')
var jwt = require('jwt-simple')
var config = require('../config/dbconfig')
var db = require('../config/db')
const nodemailer = require('nodemailer')
//const { post } = require('../routes')
var dateFormat = require("dateformat");
//const { isValidObjectId } = require('mongoose')
const path = require('path');
const fs = require('fs');
var mongoose = require('mongoose')


var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'ymaliksaqib@gmail.com',
      pass: 'zyjceecdezdorabh'
    }
  });
  

var functions = {
    addNew: function(req, res){
        if((!req.body.email) || (!req.body.password) || (!req.body.name)){
            res.json({success: false, msg: "Enter all fields"})
        }
        else{
            ///////
            users.findOne({
                email: req.body.email
            }, function(err, user){
                if(err) 
                    throw err
                if(user){
                    res.json({success: false, msg: "Signup Failed, user with this email already exists"})
                }
                else{
                    var newUser = users({
                        email: req.body.email,
                        name: req.body.name,
                        password: req.body.password
                    });
                    newUser.save(function(errr, userr){
                        if(errr){
                            res.json({success: false, msg: "Failed to save"})
                        }
                        else{
                            res.json({success: true, msg: userr})
                        }
                    })
                    
                }});
            //////
            
        }
    },
    sendMail: function (req, res){
        var mailOptions = {
            from: 'Fruit Doctor',
            to:    `${req.body.email}`,
            subject: 'Confirm Email',
            text: `Your Confirmaiton Code: ${req.body.code}`
          };
          
          transporter.sendMail(mailOptions, function(error, info){
            if (error) {
                res.json({success: false, msg: `${error}`})
            } else {
                res.json({success: true, msg: 'Code sent, check your Email!'})
            }
          });
    },
    updatePassword: function(req, res){
        users.findOne({
            email: req.body.email
        }, function(err, user){
            if(err) 
                throw err
            if(!user){
                res.json({success: false, msg: "User does not exist"})
            }
            else{
                
                user.password = req.body.password;
                user.save(function (err, user) {
                    if (err) {
                      res.json({success: false, msg: err});
                    } else {
                      res.json({success: true, msg: "Password Updated Successfully!"});
                    }
                  });
            }});
    },
    authenticate: function (req, res){
        users.findOne({
            email: req.body.email
        }, function(err, user){
            if(err) 
                throw err
            if(!user){
                res.json({success: false, msg: "Authentication failed, User not found"})
            }
            else{
                user.comparePassword(req.body.password, function(err2, isMatch){
                    if(isMatch && !err2){
                            var token = jwt.encode(user, config.secret)
                            res.json({success: true, token: token})
                    }
                    else{
                        return res.json({success: false, msg: "Authentication failed, Wrong Password!"})
                    }

                })
            }
        })
    },
    getinfo: async function(req, res){
        if(req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer'){
            var token = req.headers.authorization.split(' ')[1]
            var decodedtoken = jwt.decode(token, config.secret)
            
            var photoUrl;
            var rating;
            var rank;
            await users.findOne({
                email: decodedtoken.email
            }, function(err, user){
                if(err) 
                    throw err
                else{
                    photoUrl = user.pictureUrl
                    rating = user.rating
                    rank = user.rank
                }
                    });
            return res.json({success: true, name: decodedtoken.name, email: decodedtoken.email, pictureUrl: photoUrl, rating: rating, rank: rank})//decodedtoken.name
        }
        else{
            return res.json({success: false, msg: 'No Headers'})
        }
    },
    postQuery: async function(req,res) {
        var author;
        var now = new Date();
        var newPost;
        await users.findOne({
            email: req.body.user
        }, function(err, user){
            if(err) 
                throw err
            else
                author = user
            
        });
        newPost = thread.Thread({
            subject: req.body.subject,
            query: req.body.query,
            author: author._id,
            imageURL: req.body.image,
            postDate: now,
            relatedFruit: req.body.fruit,
            replies: []
        });
        newPost.save(function(errr, savedPost){
            if(errr){
                return res.json({success: false, msg: errr})
            }
            else{
                return res.json({success: true, msg: savedPost})
            }
        })
        
    },
    // getLikers: function(req,res){
    //     thread.Thread.findById("6044973db974320004a1d599")
    //                             .then((threadd) => {
    //                                 res.statusCode = 200;
    //                                 res.setHeader('Content-Type', 'application/json');
    //                                 res.json(threadd.likers);
    //                                 res.end();
    //                             })
    // },
    getQueries: function(req, res){
        thread.Thread.find({})
        .populate('author')
        .populate('replies.author')
                .then((threads) => {
                    res.statusCode = 200;
                    res.setHeader('Content-Type', 'application/json');
                    res.json(threads);
                    res.end();
            }, function(err, threads){
                if(err) 
                    throw err
            });
    },
    getReplies: function(req, res){
        thread.Thread.findById(req.params.queryId)
        .populate('author')
        .populate('replies.author')
                .then((thread) => {
                    res.statusCode = 200;
                    res.setHeader('Content-Type', 'application/json');
                    res.json(thread['replies']);
                    res.end();
            }, function(err, threads){
                if(err) 
                    throw err
            });
    },
    rateQuery: async function(req, res){
        if(req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer'){
            var token = req.headers.authorization.split(' ')[1]
            var decodedtoken = jwt.decode(token, config.secret)
            
            await users.findOne({
                email: decodedtoken.email
            }, function(err, user){
                if(err) 
                    throw err
                else{
                    thread.Thread.findById(req.params.queryId)
                                .then((threadd) => {
                                    users.findById(threadd.author).then((author) => {
                                        var liker = threadd.likers.find(obj => obj.email === user.email);
                                    if(liker){
                                        threadd.likers = threadd.likers.filter(item => item.email !== user.email);
                                        thread.Thread.findByIdAndUpdate(
                                            threadd._id, {$set: {likers: threadd.likers }}
                                        , function(errr, thr){
                                            if(errr) 
                                                throw err
                                        })
                                        //updating the rating of the query author
                                        var newRating = author.rating - 5;
                                        
                                        newRating = Number(newRating);
                                        //updating the rank of the query author
                                        var newRank = author.rank;
                                        if(author.rating < 500){
                                            newRank = "BEGINNER"
                                        }
                                        else if(author.rating < 1000){
                                            newRank = "INTERMEDIATE"
                                        }

                                        users.updateOne(
                                            {email: author.email}, {$set: {rating: newRating, rank: newRank }}
                                        , function(errr, userr){
                                            if(errr) 
                                                throw err
                                        })
                                        
                                    }else{
                                        threadd.likers.push(user);
                                        thread.Thread.findByIdAndUpdate(
                                            threadd._id, {$set: {likers: threadd.likers }}
                                        , function(errr, thr){
                                            if(errr) 
                                                throw err
                                        })
                                        //updating the rating of the query author
                                        var newRating = author.rating + 5;
                                        
                                        newRating = Number(newRating);
                                        //updating the rank of the query author
                                        var newRank = author.rank;
                                        if(author.rating >= 1000){
                                            newRank = "EXPERT"
                                        }
                                        else if(author.rating >= 500){
                                            newRank = "INTERMEDIATE"
                                        }

                                        users.updateOne(
                                            {email: author.email}, {$set: {rating: newRating, rank: newRank }}
                                        , function(errr, userr){
                                            if(errr) 
                                                throw err
                                        })
                                        
                                    }
                                    res.statusCode = 200;
                                    res.setHeader('Content-Type', 'application/json');
                                    res.json({"success": true, "likers": threadd.likers});
                                    res.end();
                                    })
                                    
                            }, function(errr, threads){
                                if(errr) 
                                    throw errr
                            });
                }
            
                    });
        
        }
    },
    
    rateReply: async function(req, res){
        if(req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer'){
            var token = req.headers.authorization.split(' ')[1]
            var decodedtoken = jwt.decode(token, config.secret)
            
            await users.findOne({
                email: decodedtoken.email
            }, async function(err, user){
                if(err) 
                    throw err
                else{
                    // var newObjectId=new mongoose.Types.ObjectId(req.params.replyId);
                    // var params={
                    //             '_id':newObjectId
                    // }
                    thread.Thread.findById(req.params.queryId)
                                .then(async(thrd) => {
                                    console.log(thrd);
                                    users.findById(thrd.replies.id(req.params.replyId).author).then(async(author) => {
                                        var liker = thrd.replies.id(req.params.replyId).likers.find(obj => obj.email === user.email);
                                    if(liker) {
                                        thrd.replies.id(req.params.replyId).likers = thrd.replies.id(req.params.replyId).likers.filter(item => item.email !== user.email);
                                        await thrd.save().then((th) => {});
                                        // thread.Thread.findByIdAndUpdate(
                                        //     thrd._id, {$set: {likers: thrd.replies.id(req.params.replyId).likers }}
                                        // , function(errr, rep){
                                        //     if(errr) 
                                        //         throw err
                                        // })
                                        //updating the rating of the reply author
                                        var newRating = author.rating - 5;
                                        
                                        newRating = Number(newRating);
                                        //updating the rank of the reply author
                                        var newRank = author.rank;
                                        if(author.rating < 500){
                                            newRank = "BEGINNER"
                                        }
                                        else if(author.rating < 1000){
                                            newRank = "INTERMEDIATE"
                                        }

                                        users.updateOne(
                                            {email: author.email}, {$set: {rating: newRating, rank: newRank }}
                                        , function(errr, userr){
                                            if(errr) 
                                                throw err
                                        })
                                        
                                    }else{
                                        thrd.replies.id(req.params.replyId).likers.push(user);
                                        await thrd.save().then((th) => {});
                                                    // res.statusCode = 200;
                                                    // res.setHeader('Content-Type', 'application/json');
                                                    // res.json(dish);
                                            
                                        // thread.Thread.findByIdAndUpdate(
                                        //     thrd._id, {$set: {likers: thrd.replies.id(req.params.replyId).likers }}
                                        // , function(errr, rep){
                                        //     if(errr) 
                                        //         throw err
                                        // })
                                        //updating the rating of the query author
                                        var newRating = author.rating + 5;
                                        
                                        newRating = Number(newRating);
                                        //updating the rank of the query author
                                        var newRank = author.rank;
                                        if(author.rating >= 1000){
                                            newRank = "EXPERT"
                                        }
                                        else if(author.rating >= 500){
                                            newRank = "INTERMEDIATE"
                                        }

                                        users.updateOne(
                                            {email: author.email}, {$set: {rating: newRating, rank: newRank }}
                                        , function(errr, userr){
                                            if(errr) 
                                                throw err
                                        })
                                        
                                    }
                                    res.statusCode = 200;
                                    res.setHeader('Content-Type', 'application/json');
                                    res.json({"success": true, "likers": thrd.replies.id(req.params.replyId).likers});
                                    res.end();
                                    })
                                    
                            }, function(errr, threads){
                                if(errr) 
                                    throw errr
                            });
                }
            
                    });
        
        }
    },
    
    postReply: async function(req, res) {
        var author;
        var now = new Date();
        var Reply;
        await users.findOne({
            email: req.body.replierEmail
        }, function(err, user){
            if(err) 
                throw err
            else
                author = user
            
        });
        Reply = thread.Reply({
            replyText: req.body.replyText,
            ratings: 0,
            author: author,
            postDate: now
        });
        var err;
        
        thread.Thread.findById(req.body.postID)
        .then((thread2) => {
            console.log(req.body.postID);
            if (thread2 != null) {
                thread2.replies.push(Reply);
                thread2.save()
                .then((thread3) => {
                    console.log(req.body.postID);
                    thread.Thread.findById(thread3._id)
                    .populate('replies.author')
                    .then((thread4) => {
                        console.log(req.body.postID);
                        res.statusCode = 200;
                        res.setHeader('Content-Type', 'application/json');
                        res.json({success: true, data: thread4
                        });
                    })            
                }, function(err, threads){
                    if(err) 
                        throw err
                });
            }
            else {
                err = new Error('Dish ' + req.body.postID + ' not found');
                err.status = 404;
                return next(err);
            }
        }, function(err, threads){
            if(err) 
                throw err
        });
    },
    updateUser: async function(req, res) {
        if((!req.body.email) || (!req.body.pictureUrl)){
            res.json({success: false, msg: "Please Select a Picture!"})
        }
        else{
            ///////
            users.findOne({
                email: req.body.email
            }, function(err, user){
                if(err) 
                    throw err
                if(user){
                    users.updateOne(
                        {email: req.body.email}, {$set:{pictureUrl: req.body.pictureUrl}}
                    , function(errr, userr){
                        if(errr) 
                            throw err
                        if(!userr){
                            res.json({success: false, msg: "Failed to update the profile picture!"})
                        
                        }
                        else if(userr){
                            res.json({success: true, msg: "Profile Picture Updated!"})
                        }
                    })}});
                    
                //})})}
        }

    },
    getCure: async function(req, res){
        fs.readFile('cure.json', (err, data) => {
            if (err) throw err;
            let result = JSON.parse(data);
            try{
                if(result['cures'][req.params.fruit]){
                    if(result['cures'][req.params.fruit][req.params.disease]){
                        let diagnosis = result['cures'][req.params.fruit][req.params.disease]
                        let chemCures = Object.keys(diagnosis.chemical).length;
                        let bioCures = Object.keys(diagnosis.biological).length;
                        res.json({success: true, data: diagnosis, chemCures: chemCures, bioCures: bioCures})
                    }
                    
                }
                else{
                    res.json({success: false})
                }
            }
            catch(error){
                throw error
            }
                
            
        });
    }

}


module.exports = functions