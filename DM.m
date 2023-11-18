%{

Dominant Pixels based Median Filter (DM)

%}


function out=DM(img,win,T)
[~,~,D]=size(img);
out=img; % pre-memory
for i=1:D
    out(:,:,i)=filter_DM_(img(:,:,i),win,T);
end
out=uint8(out);

% ----------------------------------------------------------------------

function OutImg=filter_DM_(img,win,T)
img=double(img);
fnc = @(x,k,l,T) sum( sum( abs(x-x(k,l)) <= T ) );  % Eq. 2
OutImg=double(img);
w0=(win-1)/2;
imj=padarray(img,[w0 w0],'symmetric');
[M,N]=size(imj);
for C1=w0+1:M-w0
    for C2=w0+1:N-w0
        Omega=imj( C1-w0:C1+w0 , C2-w0:C2+w0 ); % Eq.1
        A=ones(win,win); % memory
        for C3=1:win
            for C4=1:win
                A(C3,C4)=fnc(Omega,C3,C4,T);  % Eq. 2
            end
        end
        d = A==max(A(:)); % Eq. 3
        Delta  = Omega(d==1);
        OutImg(C1,C2) = median(Delta(:));
    end
end
OutImg=OutImg(w0+1:M-w0,w0+1:N-w0,:);
OutImg=uint8(OutImg);








