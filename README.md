# Bacterial-Growth-Rate

Objective: I created these programs to quickly and accurately measure bacterial colony growth rates and colony
           deformations. The lab I joined was studying gap formation that was observed between genetically identical 
           bacterial species. Measurements were typically collected manually using rulers. I created these programs to
           automate data collection which enabled my lab to collect more data that was also more reliable. 


IntegratedGapMeasurement.m : This program measures the distance of the gap formed between two colonies of P. syringae. 
                             Hundreds of measurements are taken between the colonies and an average value of the gap
                             distance in pixels is returned. An example of an analyzed image is included, 
                             Ex-Gap Width Image.jpg.


GrowthRate.m : This program measures the growth rate of the bacterial colony. The measurements were performed on
               Ex- Colony Growth.mp4. To collect measurements, the mp4 was split into individual frames and each 
               frame was analyzed using the MATLAB imageBatchProcessor. An example of the graphed results are also
               included, Ex- Growth Rate Four Directions.fig.
               
