# Tap Position Inference

Inference the tap position of the mobile devices.

## Description

The project is based on the Georgia State University Global Capstone Project.

The demo app was developed with Flutter. (tapping_zones dir.)

It simply save the snapshot of the 12-tapping zone's information. (Gyroscope, Accelerometer and Tapped Position Coordinate)

The app will also send collected snapshot data to Firestore.

By using those colledted data, we can build our inference model with small neural network. (Keras, Tensorflow 2.0)

You may see how it actually works on the inference ipynb files.

## Author

Honggeun Ji
[@HONGGEUN](https://www.linkedin.com/in/honggeunji/)

## Version History

* 0.1
    * Initial Release without Flutter Codes
 * 0.2
    * First version with noisy sensor data
 * 0.3
    * Second version with sensor data fusion and noisy data

## Acknowledgements
Dr. Yingshu Li (Professor, Department of Computer Science, Georgia State University)

Chenyu Wang (Ph.D. Candidate, Department of Computer Science, Georgia State University)
