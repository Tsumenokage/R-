close all;
clear all;
load('incrustation.mat')

Video=VideoReader('vid_in.mp4');
numFrames = get(Video,'NumberOfFrames');
frame = 1;
MatrixSeuil=zeros(1,numFrames);





for i=frame:3
   CurrentPic=read(Video,i);
    
   TermeGeneral = double(CurrentPic);
   TermeGeneral(:,:,1) = TermeGeneral(:,:,1)-vecteurMoyenne(1);
   TermeGeneral(:,:,2) = TermeGeneral(:,:,2)-vecteurMoyenne(2);
   TermeGeneral(:,:,3) = TermeGeneral(:,:,3)-vecteurMoyenne(3);

   
   [LargeurVideo,HauteurVideo,RGB] = size(CurrentPic);
   DistanceMahalanobis = zeros(LargeurVideo,HauteurVideo);


   for x=1:LargeurVideo
       for y=1:HauteurVideo
          TermeMaha=[TermeGeneral(x,y,1),TermeGeneral(x,y,2),TermeGeneral(x,y,3)];
          TransposeMaha = transpose(TermeMaha);
          DistanceMahalanobis(x,y) = (TermeMaha) * inv(MatriceCovariance)* (TransposeMaha);
          
          
          if(DistanceMahalanobis(x,y) < Seuil)
              DistanceMahalanobis(x,y) = 0;
          else
              DistanceMahalanobis(x,y) = 1;
          end;
        
       end
   end
   
   MatrixSeuil(1,:,i) = DistanceMahalanobis;
   %imagesc(DistanceMahalanobis)
   
end