close all
clear all

Video=VideoReader('vid_in.mp4');
numFrames = get(Video,'NumberOfFrames');

%On sélectionne la 1ère frame de la vidéo
FirstPic = read(Video,1);
imshow(FirstPic)

%On sélectionne l'un des picots
p = ginput(2)
sp(1) = min(floor(p(1)), floor(p(2))); %xmin
sp(2) = min(floor(p(3)), floor(p(4))); %ymin
sp(3) = max(ceil(p(1)), ceil(p(2)));   %xmax
sp(4) = max(ceil(p(3)), ceil(p(4)));   %ymax
PicotPicture = FirstPic(sp(2):sp(4), sp(1): sp(3),:);
figure; image(PicotPicture);


%On calcule la moyenne des compossante RGB
vecteurMoyenne = [0,0,0];
for k=1:3
    vecteurMoyenne(k) = mean(mean(PicotPicture(:,:,k)));
end

MatriceCovariance = [0,0,0
    0,0,0
    0,0,0];

for i=1:3
   PartieGauche = PicotPicture(:,:,i)-vecteurMoyenne(i);
   for j=1:3
       PartieDroite = PicotPicture(:,:,j)-vecteurMoyenne(j);
       MatriceCovariance(i,j) = sum(sum(PartieGauche().*PartieDroite()));
   end
end

[hauteur, largeur] = size(PicotPicture);
MatriceCovariance = MatriceCovariance/(hauteur*largeur);

TermeGeneral = double(FirstPic);
TermeGeneral(:,:,1) = TermeGeneral(:,:,1)-vecteurMoyenne(1);
TermeGeneral(:,:,2) = TermeGeneral(:,:,2)-vecteurMoyenne(2);
TermeGeneral(:,:,3) = TermeGeneral(:,:,3)-vecteurMoyenne(3);

[LargeurVideo,HauteurVideo,RGB] = size(FirstPic);
DistanceMahalanobis = zeros(LargeurVideo,HauteurVideo);


% for x=1:LargeurVideo
%     for y=1:HauteurVideo
%        TermeMaha=[TermeGeneral(x,y,1),TermeGeneral(x,y,2),TermeGeneral(x,y,3)];
%        TransposeMaha = transpose(TermeMaha);
%        DistanceMahalanobis(x,y) = (TermeMaha) * inv(MatriceCovariance)* (TransposeMaha);
%     end
% end

TermeMaha=[TermeGeneral(:,:,1),TermeGeneral(:,:,2),TermeGeneral(:,:,3)];
DistanceMahalanobis(:,:) = TermeMaha.*(inv(MatriceCovariance)*TermeMaha);

imagesc(DistanceMahalanobis), colorbar

Seuil = 1000;

save('incrustation.mat','Seuil','vecteurMoyenne','MatriceCovariance');
