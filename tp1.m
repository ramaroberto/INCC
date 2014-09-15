screenNum =0;
res =[1281 800];
teclaApretada = [];
apariciones = [];
clrdepth=32;
[win,rect]=Screen('OpenWindow',screenNum,0,[0 0 res(1) res(2)], clrdepth);
black=BlackIndex(win);
white=WhiteIndex (win) ;
Screen('FillRect',win,black);
refresh = Screen('GetFlipInterval',win);
%Synchronize to retrace at start of trial/animation loop:
vbl = Screen('Flip', win);
% Loop : Cycle through 300 images :
%myImage=255*rand(100, 100);
%Screen(?FrameOval?, window, color, boundingrect [, penWidth]);
%Screen('MakeTexture', win, myImage);
%Screen('DrawTexture', win, textureIndex);

% imagenesSubliminales = []
% imagenesSecundarias = [[]]

% Aviso de warning de mac
% Pantalla negra con la descripcion de la tarea
% "A continuacion apareceran grupos de 3 imagenes. La tarea consiste en
% escribir una palabra que se relacione con ellas. 
%Oprimir la barra espaciadora antes de escribir la palabra"
% wait_init
% 


semaforo = 0;
tic
for i=1:209
    %Draw i?th image to backbuffer:
    %Screen('DrawTexture', win, textureIndex);
    %Show images exactly 2 refresh cycles apart of each other:
    [down, secs, keycode]=KbCheck;
    if down==1
        if semaforo==0
            teclaApretada = [teclaApretada; secs];
            semaforo = 1;
        end
    else
        semaforo=0;
    end
    
    if mod(i,10)~=0
        Screen('FillRect',win,black);
    else
        if size(teclaApretada,1) < ceil(i/10)
            teclaApretada = [teclaApretada; 10000];
        end
        apariciones = [apariciones; GetSecs];
        Screen('FillOval', win, white, [500 350 650 450]);
    end
    
    vbl = Screen('Flip', win, vbl + (2-0.1) * refresh);
    WaitSecs(0.005);
    %Keyboard checks , whatever ... Next loop iteration .
end;
%End of animation loop , blank screen , record offset time :
toffset = Screen('Flip', win, vbl + (2 - 0.5) * refresh);
toc
Screen('CloseAll');
ShowCursor;
apariciones
teclaApretada
resultadoFallo = teclaApretada(1:20) - apariciones