import tensorflow as tf

# Load the .h5 model
model = tf.keras.models.load_model('C:\Users\Usman Saleem\Downloads\Trained Model (CNN)\Trained Model (CNN)')

# Convert to TFLite model
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the converted model
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)
