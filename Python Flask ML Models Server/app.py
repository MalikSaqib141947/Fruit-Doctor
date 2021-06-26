from flask import Flask, request
from PIL import Image

import tensorflow as tf

import numpy as np

from  tensorflow import  keras
from tensorflow.keras.preprocessing.image import img_to_array
from tensorflow.keras.preprocessing.image import load_img
from tensorflow.keras.applications.efficientnet import preprocess_input
#from efficientnet.keras import EfficientNetB7

app = Flask(__name__)



@app.route('/grading_model', methods=['POST'])
def grading_model():
    img = None
    try:
        img = request.files.get('img', '')
    except Exception as e:
        print(e)

    
    model = keras.models.load_model(r'D:/class/fyp/project/temp/src/scraping/gradingEfficientB07vF1.h5')

    img = Image.open(img)
    img.save('fruit.jpg')

    img = load_img(r'D:\\class\\fyp\\project\\temp\\src\\scraping\\fruit.jpg', target_size = (100,100))
    img= img_to_array(img)
    img = img/255
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)
    pred = model.predict(img)
    print(pred)

    index = np.argmax(pred)
    categories= ['Apple Green','Apple Red G1','Apple Red G2','Apple Yellow', 'Banana Yellow','Banana Green', 'Banana Rotten', 'Orange G1', 'Rotten Orange']

    print(categories[index])

    json_fruit = {"name" : categories[index]}
    return json_fruit

@app.route('/predictStrawberryDisease', methods=['POST'])
def predict_strawberry_disease():
    img = None
    try:
        img = request.files.get('img', '')
    except Exception as e:
        print(e)
    

    import tensorflow
    import tensorflow.keras.applications.inception_resnet_v2
    from tensorflow.keras.applications.inception_resnet_v2 import preprocess_input
    
    model = tensorflow.keras.models.load_model(r'C:/Final Year Project/model data/citrus_disease_classifier.h5')

    img = Image.open(img)
    img.save('fruit.jpg')

    img = load_img(r'C:/Final Year Project/model data/fruit.jpg', target_size = (100,100))
    img= img_to_array(img)
    img = img/255
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)
    pred = model.predict(img)
    print(pred)

    index = np.argmax(pred)
    categories= ['Leaf Scrotch', 'Healthy']

    print(categories[index])

    json_fruit = {"name" : categories[index]}
    return json_fruit

@app.route('/predictPapayaDisease', methods=['POST'])
def predict_papaya_disease():
    img = None
    try:
        img = request.files.get('img', '')
    except Exception as e:
        print(e)
    

    import tensorflow

    model = tensorflow.keras.models.load_model(r'C:/Final Year Project/model data/papaya_disease_classifier.h5')

    img = Image.open(img)
    img.save('fruit.jpg')

    img = load_img(r'C:/Final Year Project/model data/fruit.jpg', target_size = (100,100))
    img= img_to_array(img)
    img = img/255
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)
    pred = model.predict(img)
    print(pred)

    index = np.argmax(pred)
    categories= ['anthracnose','black_spot','phytophthora','powdery_mildew', 'ring_spot']

    print(categories[index])

    json_fruit = {"name" : categories[index]}
    return json_fruit


@app.route('/predictAppleDisease2', methods=['POST'])
def predict_apple_disease2():
    img = None
    try:
        img = request.files.get('img', '')
    except Exception as e:
        print(e)
    

    import tensorflow

    model = tensorflow.keras.models.load_model(r'C:/Final Year Project/model data/apple_disease_classifier_weights.h5')

    img = Image.open(img)
    img.save('fruit.jpg')

    img = load_img(r'C:/Final Year Project/model data/fruit.jpg', target_size = (100,100))
    img= img_to_array(img)
    img = img/255
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)
    pred = model.predict(img)
    print(pred)

    index = np.argmax(pred)
    categories= ['anthracnose','black_spot','phytophthora','powdery_mildew']

    print(categories[index])

    json_fruit = {"name" : categories[index]}
    return json_fruit


@app.route('/predictAppleDisease', methods=['POST'])
def predict_apple_disease():
    img = None
    try:
        img = request.files.get('img', '')
    except Exception as e:
        print(e)
    

    import tensorflow
    import random
    from scipy.stats import loguniform
    import math

    l2_reg = tensorflow.keras.regularizers.l2()
    base_model = tensorflow.keras.applications.InceptionResNetV2(weights="imagenet",
    input_shape=(100, 100, 3),
    include_top=False,
    classes = 4)

    model = tensorflow.keras.Sequential()
    #model.add(base_model)
    #x = base_model.output

    #x = tensorflow.keras.Input(shape=(100,100,3))

    model.add(tensorflow.keras.layers.Flatten())
    model.add(tensorflow.keras.layers.Dense(128, activation='relu'))
    model.add(tensorflow.keras.layers.Dropout(rate=0.1))
    model.add(tensorflow.keras.layers.Dense(64, activation='relu'))
    model.add(tensorflow.keras.layers.Dropout(rate=0.2))
    model.add(tensorflow.keras.layers.Dense(32, activation='relu'))
    model.add(tensorflow.keras.layers.Dropout(rate=0.2))
    model.add(tensorflow.keras.layers.Dense(16, activation='relu'))
    model.add(tensorflow.keras.layers.Dropout(rate=0.2))
    model.add(tensorflow.keras.layers.Dense(8, activation='relu'))
    model.add(tensorflow.keras.layers.Dropout(rate=0.2))
    model.add(tensorflow.keras.layers.Flatten())
    model.add(tensorflow.keras.layers.Dense(5, activation='softmax'))
    
    print(len(base_model.layers))
    #base_model.trainable = False
    for i in range(int(len(base_model.layers) * random.uniform(0, 1))):
        layer = base_model.layers[i]
        layer.trainable = False
    #x = base_model.output
    #x = tensorflow.keras.layers.GlobalAveragePooling2D()(x)
    #x = tensorflow.keras.layers.Dropout(rate = 0.1)(x)
    #x = tensorflow.keras.layers.Dense(1024, activation='relu', kernel_regularizer=l2_reg, activity_regularizer=l2_reg)(x)
    #x = tensorflow.keras.layers.Dropout(rate = 0.1)(x)
    #predictions = tensorflow.keras.layers.Dense(4, activation='softmax', kernel_regularizer=l2_reg, activity_regularizer=l2_reg)(x)
    #model = tensorflow.keras.Model(inputs=base_model.input, outputs=predictions)
    #model.save_weights(r'C:/Final Year Project/model data/apple5_disease_classifier.h5')
    
    model.load_weights(r'C:/Final Year Project/model data/papaya_disease_classifier.h5', by_name=True)
    json_string = model.to_json()
    model = tensorflow.keras.models.model_from_json(json_string)
    model.compile(optimizer='adam', loss = "categorical_crossentropy" , metrics =['accuracy'])
    #model.load_weights(r'C:/Final Year Project/model data/apple_disease_classifier.h5')

    #model = tensorflow.keras.models.load_model(r'C:/Final Year Project/model data/apple_disease_classifier.h5')
    img = Image.open(img)
    img.save('fruit.jpg')

    img = load_img(r'C:/Final Year Project/model data/fruit.jpg', target_size = (100,100))
    img= img_to_array(img)
    img = img/255
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)
    pred = model.predict(img)
    print(pred)

    index = np.argmax(pred)
    categories= ['Apple Scab','Black Rot','Cedar Apple Rust','Healthy']

    print(categories[index])

    json_fruit = {"name" : categories[index]}
    return json_fruit

    




@app.route('/')
def connect():
    return "Connected"

if __name__ == '__main__':
    app.run()

