var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var bcrypt = require('bcrypt');

var userSchema = new Schema({
    email: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    forgotPassword: {
        type: Boolean,
        default: false,
    },
    pictureUrl: {
        type: String,
        required: false
    },
    rating:{
        type: Number,
        required: false,
        default: 0
    },
    rank: {
        type: String,
        enum: ["BEGINNER", "INTERMEDIATE", "EXPERT"],
        required: false,
        default: "BEGINNER"
    }



})

//encrypting the password if it is either newly entered or is being modified
userSchema.pre('save', function(next){
    var user = this;
    if(this.isModified('password') || this.isNew){
        bcrypt.genSalt(10, function(err, salt){
            if(err){
                return next(err)
            }
            bcrypt.hash(user.password, salt, function(err2, hash){
                if(err2){
                    return next(err2)
                }
                user.password = hash;
                next();
            })
        })
    }
    else{
        return next()
    }
})

//Updating the rank of the user if rating is updated
// userSchema.pre(['updateOne', 'findOneAndUpdate'], function(next, err){
//     if(err)
//         return next(err)
//     var user = this;
//     if(this.isModified('rating')){
//         if(user.rating <500)
//             user.rank = 'BEGINNER'
//         else if(user.rating >= 500 && user.rating <1000)
//             user.rank = 'INTERMEDIATE'
//         else if(user.rating >= 1000)
//             user.rank = 'EXPERT'
//         next();
//     }
//     else{
//         return next()
//     }
// })

userSchema.methods.comparePassword = function(passw, cb){
    bcrypt.compare(passw, this.password, function(err, isMatch){
        if(err){
            return cb(err)
        }
        cb(null, isMatch)
    })
}

module.exports = mongoose.model('users', userSchema)
//exports.userSchema = userSchema;

/*
Nothing, just sample code
///////////
////////////
/////////////
///////////
/////////
/////////////
//////////////////////
*/