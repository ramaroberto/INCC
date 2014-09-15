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


imagenesSubliminales = [];
imagenesSecundarias = [[]];
imagenesSubliminalesFruta = [];
imagenesSecundariasFruta = [[]];

wait_pl1 = 2;  % Tiempo que dura la primer pantalla para limpiar retina
wait_is = 0.0050;   % Tiempo que se muestra la imagen subliminal
wait_pl2 = 2;  % Tiempo que dura la segunda pantalla para limpiar retina


% Aviso de warning de mac
% Pantalla negra con la descripcion de la tarea:
% "A continuacion apareceran grupos de 3 imagenes. La tarea consiste en
% escribir una palabra que se relacione con ellas. 
% Debera oprimir la barra espaciadora recien cuando este listo para escribir la palabra.
% Presione una tecla para continuar."
% wait_init
Screen('FillRect',win,black);
% TODO: mostrar descripcion

% Bucle i = 1:size(imagenesSubliminales)
% Preguntar: pantalla para limpiar retina
% wait_pl1
% Mostrar imagen subliminal
% wait_is
% Pantalla limpia-retina
% wait_pl2
% Imagenes secundarias
% Comenzar a medir tiempo
% wait barra espaciadora
% Input de texto para escribir
% wait enter
% Finalizar medicion de tiempo, guardar tiempo y respuesta


semaforo = 0;
tic
for i=1:209
    
    Screen('FillRect', win, white); % Limpia retina
    WaitSecs(wait_p1);
    
    % TODO: Mostrar imagen suubliminal
    WaitSecs(wait_is);
    
    Screen('FillRect', win, white); % Limpia retina
    WaitSecs(wait_p2);
    
    % TODO: Mostrar imagenes secundarias
    
    
    %Draw i?th image to backbuffer:
    %Screen('DrawTexture', win, textureIndex);
    %Show images exactly 2 refresh cycles apart of each other:
    [down, secs, keycode]=KbCheck;
    Screen('FillRect', win, black);
    WaitSecs(0.005);
    %Keyboard checks , whatever ... Next loop iteration .
end;
%End of animation loop , blank screen , record offset time :
%toffset = Screen('Flip', win, vbl + (2 - 0.5) * refresh);
toc

Screen('CloseAll');
ShowCursor;