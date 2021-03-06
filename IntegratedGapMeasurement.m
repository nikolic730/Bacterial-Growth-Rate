%%Innoculation points must be approximately parallel
%%to each other. Picture should be taken so that innoculation points are
%%parallel. Take all images from same distance.
%%Enter image and convert to Thresholded Image

image= imread('IMG_0001.jpg');
[c,r,P] = impixel(image);
assert(c(2,1)>c(1,1),'Select left innoculation point first!');
gs= rgb2gray(image);

%%Histogram to see the values of the
[counts,x]= imhist(gs,16);
stem(x,counts);
imhist(gs);
figure

%%Create a matrix that includes all the pixel values that dont have values
%%of zero

counter = 0;
pixelValues = zeros(1,921600,'uint16');
[RowNum,ColumnNum] = size(gs);
wholeCounter = 1;
gsInt = uint32(gs);
for i=1:1: RowNum-1
    for ik=1:1: ColumnNum-1
        if(gsInt(i,ik)>=25)
            pixelValues(1,wholeCounter)= gsInt(i,ik);
            wholeCounter= wholeCounter + 1;
        end
    end
end

NonZeroPixelValues=zeros(1,wholeCounter);

for i=1: 1 : wholeCounter
    NonZeroPixelValues(1,i)= pixelValues(1,i);
end


%%Check histogram values of NonZeropixelValues.


level= graythresh(NonZeroPixelValues);
thres= imbinarize(gs,level);
imshow(thres);


%%Compute the variables necessary for loop and create average center
%variable.

averageCenterRow= uint32((r(1,1) + r(2,1))/2);
columnLeft= uint32(c(1,1));
columnRight= uint32(c(2,1));

%%Write a loop to find the value of Left, top center pixels

LeftPixelsUp=averageCenterRow;
LeftUpCounter= 0;
conditionalLT=true;

while (conditionalLT==true)
    if (thres(LeftPixelsUp, columnLeft)==1)
        LeftUpCounter= LeftUpCounter + 1;
        LeftPixelsUp= LeftPixelsUp - 1;
    else
        conditionalLT=false;
    end
end

LeftUpRow= uint32(averageCenterRow - ((LeftUpCounter)/2));

%%Write a loop to find the value of Left, bottom center pixels

LeftPixelsDown=averageCenterRow;
LeftDownCounter=0;
conditionalLD=true;

while (conditionalLD==true)
    if (thres(LeftPixelsDown, columnLeft)==1)
        LeftPixelsDown= LeftPixelsDown + 1;
        LeftDownCounter= LeftDownCounter + 1;
    else
        conditionalLD=false;
    end
end

LeftDownRow= uint32(averageCenterRow + ((LeftDownCounter)/2));

%%Write a loop to find the value of Right, top pixels

RightPixelsUp=averageCenterRow;
conditionalRT=true;
RightTopCounter=0;

while (conditionalRT==true)
    if (thres(RightPixelsUp, columnRight)==1)
        RightPixelsUp= RightPixelsUp - 1;
        RightTopCounter= RightTopCounter + 1;
    else
        conditionalRT=false;
    end
end

RightUpRow= uint32(averageCenterRow - ((RightTopCounter)/2));


%%Write a loop to find the value of Right, bottom center pixels

RightPixelsDown=averageCenterRow;
conditionalRD=true;
RightBottomCounter=0;

while (conditionalRD==true)
    if (thres(RightPixelsDown, columnRight)==1)
        RightPixelsDown= RightPixelsDown + 1;
        RightBottomCounter= RightBottomCounter + 1;
    else
        conditionalRD=false;
    end
end

RightDownRow= uint32(averageCenterRow + ((RightBottomCounter)/2));

%Compute the average Row number for the top coordinates and
%assign them one value.

TopRowAverage= uint32((LeftUpRow+RightUpRow)/2);


%Compute the average Row number for the bottom coordinates and assign them
%one value.

BottomRowAverage= uint32((LeftDownRow+RightDownRow)/2);

%%Set variables for the distance between the column coordinates

TotalDistance= columnRight-columnLeft;

%%Write a loop to find distance between top left center and gap

LeftTopColumnIncrement= columnLeft;
LTopColumnCondition=true;


while (LTopColumnCondition==true)
    if(thres(TopRowAverage, LeftTopColumnIncrement)==1)
        LeftTopColumnIncrement= LeftTopColumnIncrement + 1;
    else
        LTopColumnCondition= false;
    end
end

LTColumnDistance= LeftTopColumnIncrement- columnLeft;

%%Write a loop to find distance between top right center and gap

RightTopColumnIncrement= columnRight;
RTopColumnCondition= true;

while (RTopColumnCondition==true)
    if(thres(TopRowAverage, RightTopColumnIncrement)==1)
        RightTopColumnIncrement= RightTopColumnIncrement - 1;
    else
        RTopColumnCondition=false;
    end
end

RTColumnDistance= columnRight- RightTopColumnIncrement;

%Write a loop to find distance between center left center and gap

LeftCenterColumnIncrement= columnLeft;
LCenterColumnCondition=true;


while (LCenterColumnCondition==true)
    if(thres(averageCenterRow, LeftCenterColumnIncrement)==1)
        LeftCenterColumnIncrement= LeftCenterColumnIncrement + 1;
    else
        LCenterColumnCondition= false;
    end
end

LCColumnDistance= LeftCenterColumnIncrement- columnLeft;


%Write a loop to find distance between center right and gap

RightCenterColumnIncrement= columnRight;
RCenterColumnCondition= true;

while (RCenterColumnCondition==true)
    if(thres(averageCenterRow, RightCenterColumnIncrement)==1)
        RightCenterColumnIncrement= RightCenterColumnIncrement - 1;
    else
        RCenterColumnCondition=false;
    end
end

RCColumnDistance= columnRight- RightCenterColumnIncrement;


%Write a loop to find distance between bottom left pixel and gap

LeftBottomColumnIncrement= columnLeft;
LBottomColumnCondition=true;


while (LBottomColumnCondition==true)
    if(thres(BottomRowAverage, LeftBottomColumnIncrement)==1)
        LeftBottomColumnIncrement= LeftBottomColumnIncrement + 1;
    else
        LBottomColumnCondition= false;
    end
end

LBColumnDistance= LeftBottomColumnIncrement- columnLeft;


%Write a loop to find distance between bottom right pixel and gap

RightBottomColumnIncrement= columnRight;
RBottomColumnCondition=true;


while (RBottomColumnCondition==true)
    if(thres(BottomRowAverage,RightBottomColumnIncrement)==1)
        RightBottomColumnIncrement= RightBottomColumnIncrement - 1;
    else
        RBottomColumnCondition= false;
    end
end

RBColumnDistance= columnRight- RightBottomColumnIncrement;

%Create a condition before computing the gap lengths to make sure that
%there isnt an error occuring because of an irregularity in the image.



%Compute the bottom gap

if(((RBColumnDistance+LBColumnDistance)+5)>= TotalDistance)
    BottomGap=0;
else
    BottomGap= TotalDistance- (RBColumnDistance + LBColumnDistance);
end

disp('Bottom Gap=');
disp(BottomGap);

%Compute the center gap

if(((RCColumnDistance+LCColumnDistance)+5)>= TotalDistance)
    CenterGap=0;
else
    CenterGap= TotalDistance- (RCColumnDistance + LCColumnDistance);
end

disp('Center Gap=');
disp(CenterGap);

%Compute the Top Gap


if(((RTColumnDistance+LTColumnDistance)+5)>= TotalDistance)
    TopGap=0;
else
    TopGap= TotalDistance- (RTColumnDistance + LTColumnDistance);
end

disp('Top Gap=');
disp(TopGap);

%Convert all the gap values to uint32 data type

TopGapInt= uint32(TopGap);
CenterGapInt= uint32(CenterGap);
BottomGapInt= uint32(BottomGap);

%Average the distance of all the 3 gaps (in pixels)

AverageGap= (TopGap+CenterGap+BottomGap)/3;

disp('Average Gap=');
disp(AverageGap);


if(TopGapInt >=5 && CenterGapInt >=5 && BottomGapInt >=5)
    %Write a nested loop to find the sum of all the distances of the left
    %colony. Variables- TopRowAverage, BottomRowAverage, TotalDistance,
    %columnRight, columnLeft

    LeftSumTotal=0;

    for LeftTopRowCounter=TopRowAverage: 1: BottomRowAverage
        for LeftColumnCounter= columnLeft: 1: columnRight
            if(thres(LeftTopRowCounter,LeftColumnCounter)==1)
               LeftSumTotal= LeftSumTotal + 1;
            else
               break
            end
        end

    end


    %Write a nested loop to find the sum of all the distances of the right
    %colony. Variables- TopRowAverage, BottomRowAverage, TotalDistance,
    %columnRight, columnLeft

    RightSumTotal=0;

    for RightTopRowCounter=TopRowAverage: 1: BottomRowAverage
       for RightColumnCounter= columnRight: -1: columnLeft
          if(thres(RightTopRowCounter,RightColumnCounter)==1)
             RightSumTotal= RightSumTotal + 1;
          else
             break
          end
       end

    end


    %Sum all of the pixels calculated for Left and Right. Use TotalDistance and
    %(BottomRowAverage-TopRowAverage) to find the average length of the gaps.

    TotalSum= LeftSumTotal + RightSumTotal;
    RowLength= BottomRowAverage- TopRowAverage;
    TotalPixels= (RowLength * TotalDistance);
    AverageGapIntegrated= (TotalPixels - TotalSum) / RowLength;

    disp('Integrated Average Gap = ');
    disp(AverageGapIntegrated);

else
    disp('Gap Calculations are too narrow to find the integrated gap width.');
end


    %Export Data to excel spreadsheet

    %filename= 'GapSeparationData.xlsx';
    %T=table(TopGapInt,CenterGapInt,BottomGapInt,AverageGap);
    %writetable(T,filename);
