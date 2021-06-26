var mongoose = require('mongoose');
var Schema = mongoose.Schema;
require('mongoose-currency').loadType(mongoose);
const Currency = mongoose.Types.Currency;
var bcrypt = require('bcrypt');
//const user = require('./user.js');
const user = require('./user');
require('./user.js');


var replySchema = new Schema({
    replyText: {
        type: String,
        required: true
    },
    ratings: {
        type: Number,
        required: true
    },
    author: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'users',
        required: true
    },
    postDate: {
        type: Date,
        required: true
    },
    likers: [user.schema]
});

var threadSchema = new Schema({
    subject: {
        type: String,
        required: true
    },
    query: {
        type: String,
        required: true
    },
    author: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'users',
        required: true
    },
    imageURL: {
        type: String,
        required: false
    },
    postDate: {
        type: Date,
        required: true
    },
    relatedFruit: {
        type: String,
        required: true,
    },
    replies: [replySchema],
    likers: [user.schema]
})

var discussionThread = mongoose.model('discussionThread', threadSchema)
var Reply = mongoose.model('Reply', replySchema)

exports.Thread = discussionThread;
exports.Reply = Reply;
