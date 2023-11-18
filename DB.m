
%{
Dominant Pixels based Bilateral Filter (DB) 

%}

function out=DB(img,win,T)
img=double(img);
[~,~,D]=size(img);
out=img; % pre-memory
for i=1:D
    out(:,:,i)=filter_DB_(img(:,:,i),win,T);
end
% out=imhistmatch(uint8(out),uint8(img));

% ----------------------------------------------------------------------

function OutputImg=filter_DB_(InputImg , win , T)
InputImg = double(InputImg);
fnc = @(Omega,k,l,T) abs(Omega-Omega(k,l) ) <= T;
w0 = (win-1)/2; 
C = (win-1)/2+1;  % Center pixel
OutputImg= padarray(InputImg,[w0 w0],'symmetric');
[M,N] = size(OutputImg);
% spatial distance weights, g 
[u,v]=meshgrid( 1:win , 1:win ); u=u-C; v=v-C; 
g = sqrt(u.*u + v.*v);
g(C,C)=1/2;
g = 1./g; % normalized spatial distances
for C1=w0+1:M-w0
    for C2=w0+1:N-w0
        Omega = OutputImg( C1-w0:C1+w0 , C2-w0:C2+w0 ); % Eq.1        
        B = fnc(Omega,C,C,T)  ;        % Eq. 4
        delta = Omega(B==1);       % Eq. 4              
        w1 = delta ./ sum(delta(:)); % Eq.5 ; intensity distance weights
        w1(w1==0) = 1/128;
        w1 = 1 ./ w1; 
        w1 = w1 ./ sum(w1);
        w2 = g(B(:)==1); % spatial distance weights, g 
        OutputImg(C1,C2) = sum(w1.*w2 .* Omega(B(:)==1)) ./ sum(sum(w1.*w2 )) ; % Eq.8
    end
end
OutputImg = OutputImg( w0+1:M-w0 , w0+1:N-w0 , : );
OutputImg = uint8(OutputImg);












