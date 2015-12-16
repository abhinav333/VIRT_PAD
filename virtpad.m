%virtual drawing pad
% works with a white colour marker
%by abhinav, ankit, jomin, atharv
%video settings
vid = videoinput('winvideo', 1, 'YUY2_320x240');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;
vid.TriggerRepeat = Inf;
vid.ReturnedColorspace='rgb';
triggerconfig(vid, 'manual');
%%
%initializing matrices and other variables
dat_r=zeros(240,320);
dat_g=zeros(240,320);
dat_b=zeros(240,320);
data=zeros(240,320);
datai2=zeros(240,320);
lidat=zeros(240,320);
se=strel('line',10,51);
xp=0;
yp=0;

%%
%image grabbing
start(vid);
for i=1:1000
    m1=0;
    n1=0;
    t=1;
    img=getsnapshot(vid);              
    dat_r=(img(:,:,1)>250).*(img(:,:,1)<=255);
    dat_g=(img(:,:,2)>250).*(img(:,:,2)<=255);
    dat_b=(img(:,:,3)>250).*(img(:,:,3)<=255);
    data=dat_r.*dat_g.*dat_b;
    datai2=imdilate(imerode(data,se),se);        
    %calculating the centroid of white pixels in binary image
    for xx=1:320
        for yy=1:240
         if(datai2(yy,xx)==1)
             m1=m1+xx;
             n1=n1+yy;
             t=t+1;
         end
        end
    end
    
    cx=round(m1/t);
    cy=round(n1/t);
    if(xp~=0 && yp~=0 && cx<320 && cy<240 && cx>1 && cy>1)     
         xxx=linspace(xp,cx,100);%creating a series of numbers between x1 and x2 and storing it in matrix xxx
         yyy=linspace(yp,cy,100);
         ind=sub2ind(size(lidat),round(yyy),round(xxx));% converting the order index to linear index
         lidat(ind)=1;    
    end
    %setting the current co-ordinates as previous co-ordinates
         xp=cx;
         yp=cy;
    
        
    imshow(fliplr(lidat));
end
stop(vid);

