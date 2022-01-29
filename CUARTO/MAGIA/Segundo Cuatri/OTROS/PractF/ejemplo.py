


#IMPORTAMOS LAS LIBRERIAS NECESARIAS
from keras.datasets import mnist
from keras import models
from keras import layers 
from keras.utils import to_categorical

# Cragamos la muestra
(train_images,train_labels),(test_images,test_labels)=mnist.load_data()

# Creación de la red
network=models.Sequential()
network.add(layers.Dense(512,activation='relu',input_shape=(28*28)))
network.add(layers.Dense(10, activation='softmax'))
network.compile(optimizer='rmsprop',loss='categorical_crossentropy', metrics=['accuracy'])


# Preparación de los datos de entrada
train_images=train_images.reshape((60000,28*28)).astype('float32') / 255
test_images=test_images.reshape((60000,28*28)).astype('float32') / 255

#Preparación de las etiquetas
train_labels=to_categorical(train_labels) 
test_labels=to_categorical(test_labels)

# Entrenamiento de la red
network.fit(train_images,train_labels,epochs=5,batch_size=128)

#Evaluación de la red
test_loss,test_acc=network.evaluate(test_images,test_labels)



