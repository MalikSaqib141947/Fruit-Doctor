const express = require('express');
const { models } = require('mongoose');
const actions = require('../methods/actions');
const router = express.Router();
const multer = require('multer');
var path = require('path');
//fs = require('fs');
var cloudinary = require('cloudinary').v2
var fileUpload = require('express-fileupload')
var multipart = require('connect-multiparty');
var multipartMiddleware = multipart();

router.use(fileUpload({useTempFiles: true}));
cloudinary.config({
    cloud_name: 'fruit-doctor', //'dyk6mfuoy',//
    api_key: '594229417468341', //'299236549644773',//
    api_secret: 'zEEsz7gdzAS7SP3y5Dt47cHo_lc', //'vsugf9PLerzm9ZI1-JoaGnHXaCE',//
});

//defining storage and file name for the uploaded image
var storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'public/images');
    },

    filename: (req, file, cb) => {
        var fname = file.fieldname + '-' + Date.now() + path.extname(file.originalname);
        cb(null, fname);
    }
});



//Defining the allowed image formats
const imageFileFilter = (req, file, cb) => {
    if(!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)){
        return cb('You can upload only image files!')
    }
    cb(null, true);
};


const upload = multer({storage: storage, fileFilter: imageFileFilter});

router.get('/', (req, res) => {
    res.send('Hello World')
})

router.get('/dashboard', (req, res) => {
    res.send('Dashboard')
})

//@desc Adding new user
//@route POST /adduser
router.post('/adduser',actions.addNew)
router.post('/sendmail', actions.sendMail)
router.post('/updatepassword', actions.updatePassword)
//@desc Authenticating a user
//@route POST /authenticate
router.post('/authenticate', actions.authenticate )
//@desc Get info of a user
//@route GET /getinfo
router.get('/getinfo', actions.getinfo)
//@desc Post a query on the community Forum
//@route POST /postquery
router.post('/postquery', actions.postQuery)
router.get('/getqueries',actions.getQueries)
router.get('/getReplies/:queryId',actions.getReplies)
router.post('/postreply',actions.postReply)
router.post('/updateUser',actions.updateUser)
router.get('/getCure/:fruit/:disease', actions.getCure)
router.post('/rateQuery/:queryId', actions.rateQuery)
router.post('/rateReply/:queryId/:replyId', actions.rateReply)
//router.get('/getLikers', actions.getLikers)
//router.post('/postimage', upload.single('picture'), (req, res) => {
router.post('/postimage',  (req, res) => {
    var file = req.files.picture;

    cloudinary.uploader.upload(file.tempFilePath,
    function(err, result) {
        if(err){
            res.json({
                success: false,
                imageData: null
            })
        }
        else{
            res.json({
                success: true,
                imageData: result
            })
        }
        
        
        }
        );
    
    })


router.get('/images', (req, res) => res.sendFile('C:/Final Year Project/fruit_doctor_server_side/public/images/picture-1615040637409.jpg'))

// router.get('/confirmation/:token', async(req, res) => {
//     try{
//         //const {user: {id}} = jwt.verify(req.params.token), EMAIL_SECRET );
//         await models.users.update({confirmed: true}, {where: {id}});
//     } catch(e){
//         res.send('error');
//     }
// })

module.exports = router;