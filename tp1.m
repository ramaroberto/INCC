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
%Screen('FrameOval', window, color, boundingrect [, penWidth]);
%Screen('MakeTexture', win, myImage);
%Screen('DrawTexture', win, textureIndex);


imagenesSubliminales = [];
imagenesSecundarias = [[]];
imagenesSubliminalesFruta = [];
imagenesSecundariasFruta = [[]];

wait_pl1 = 1;  % Tiempo que dura la primer pantalla para limpiar retina
wait_is = 0.030;   % Tiempo que se muestra la imagen subliminal
wait_pl2 = 2;  % Tiempo que dura la segunda pantalla para limpiar retina

imgsec_space = 20; % Tamanio en pixels para los espacios entre las imagenes secundarias


% Aviso de warning de mac
% Pantalla negra con la descripcion de la tarea:
% "A continuacion apareceran grupos de 3 imagenes. La tarea consiste en
% escribir una palabra que se relacione con ellas.
% Debera oprimir la barra espaciadora recien cuando este listo para escribir la palabra.
% Presione una tecla para continuar."
% wait_init
Screen('FillRect',win,black);
Screen('Flip', win);
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
Screen('FillRect', win, white); % Limpia retina
Screen('TextFont',win, 'Helvetica');
Screen('TextSize',win, 30);
Screen('TextStyle', win, 1);
Screen('DrawText', win, 'A continuacion apareceran grupos de 3 imagenes.', 280, 250, [0 1 1], [0, 0, 255, 255]);
Screen('DrawText', win, 'La tarea consiste en escribir una palabra que se relacione con ellas.', 130, 350, [0 1 1], [0, 0, 255, 255]);
Screen('DrawText', win, 'Debera oprimir la barra espaciadora recien cuando este listo para escribir la palabra.', 30, 450, [0 1 1], [0, 0, 255, 255]);
Screen('TextSize',win, 50);
Screen('DrawText', win, 'Presione una tecla para continuar...', 220, 650, [0 1 1], [0, 0, 255, 255]);
Screen('Flip', win);
KbWait;
WaitSecs(wait_pl1);
for i=1:1
    % Mostramos la imagen subliminal
    imsub=imread('Equipo.jpg', 'jpg');
    Screen('PutImage', win, imsub);
    Screen('Flip', win);
    %whiteNoiseScreen(win, rect, 100, 1281);
    
    %Screen('FillRect', win, white); % Limpia retina
    %Screen('Flip', win);
    %WaitSecs(wait_pl2);
    
    % Pantalla de ruido blanco:
    % win = Referencia a la ventana, winRect = Referencia al rectangulo de
    % la ventana, nframes = Cantidad de frames que dura la pantalla con
    % ruido blanco (ahora en 100 frames), rectSize = Tamaño de la pantalla
    % de ruido blanco. El cuadrado de ruido blanco queda centrado.
    whiteNoiseScreen(win, rect, 5, 1281);
    
    
    % Mostramos imagenes secundarias
    % Cargamos las imagenes
    imsec1=imread('Matafuegos.png', 'png');
    imsec2=imread('Matafuegos.png', 'png');
    imsec3=imread('Matafuegos.png', 'png');
    
    % Obtenemos el alto mas grande de las tres imagenes
    max_height=max([size(imsec1,1); size(imsec2,1); size(imsec3,1)]);
    
    % Agregamos blanco necesario arriba y abajo a la primera imagen
    wadd=ones(floor((max_height-size(imsec1,1))/2), size(imsec1,2), 3)*255;
    padd=ones(mod(max_height-size(imsec1,1),2), size(imsec1,2), 3)*255;
    imsec1=[wadd; padd; imsec1; wadd];
    
    % Agregamos blanco necesario arriba y abajo a la segunda imagen
    wadd=ones(floor((max_height-size(imsec2,1))/2), size(imsec2,2), 3)*255;
    padd=ones(mod(max_height-size(imsec2,1),2), size(imsec2,2), 3)*255;
    imsec2=[wadd; padd; imsec2; wadd];
    
    % Agregamos blanco necesario arriba y abajo a la tercera imagen
    wadd=ones(floor((max_height-size(imsec3,1))/2), size(imsec3,2), 3)*255;
    padd=ones(mod(max_height-size(imsec3,1),2), size(imsec3,2), 3)*255;
    imsec3=[wadd; padd; imsec3; wadd];
    
    % Las pegamos
    space=ones(max_height,imgsec_space,3)*255;
    imsecs=[imsec1 space imsec2 space imsec3];
    size(imsecs)
    
    % Ponemos en pantalla y mostramos
    Screen('PutImage', win, imsecs);
    Screen('TextSize',win, 20);
    Screen('DrawText', win, 'Presione la barra de espacio cuando este listo para escribir la palabra...', 300, 700, [0 1 1], [0, 0, 255, 255]);
    Screen('DrawText', win, 'y comience a escribir', 500, 750, [0 1 1], [0, 0, 255, 255]);
    Screen('Flip', win);

    % Esperamos hasta que el usuario toque una tecla
    pressed = 0;
    while pressed == 0
        [pressed, secs, kbData] = KbCheck;
    end;
    %TODO: Como obtengo el tiempo aca?
    % Draw the characters...
    Screen('FillRect', win, white);
    % First draw the instructions
    %Screen('DrawText', win, 'This is the typing test.', 100, 100);
    Screen('DrawText', win, 'Ingresar una unica palabra. Apriete la barra espaciadora cuando haya terminado.', 100, 150);
    Screen('TextSize', win, 20);
    Screen('Flip', win);
    FlushEvents('keyDown');
    charBuffer='';
    stopLoop=0;
    lineBuffer={};
    totalChars=0;
    lineBufferIndex=0;
    startingYPosition=200;
    textHeight=0;
    textYPosition=startingYPosition;
    Screen('TextSize', win, 20);
    charsPerLine=100;
    totalLines=5;
    while ~stopLoop
        % Get the character
        c=GetChar;
        totalChars=totalChars+1;
        % test for doneness
        if streq(upper(c), ' ') || streq(upper(c), 'Q') || lineBufferIndex > totalLines
            break;
        end
        % break lines
        charBuffer=[charBuffer c];
        if length(charBuffer) == charsPerLine
            lineBufferIndex= lineBufferIndex+1;
            lineBuffer{lineBufferIndex}= charBuffer;
            charBuffer='';
        end
        % Draw the characters...
        Screen('FillRect', win, white);
        % First draw the instructions
        %Screen('DrawText', win, 'This is the typing test.', 100, 100);
        Screen('DrawText', win, 'Ingresar una unica palabra. Apriete la barra espaciadora cuando haya terminado.', 100, 150);
        Screen('TextSize', win, 20);
        % then display full lines...
        textYPosition=startingYPosition;
        for i=1:lineBufferIndex
            Screen('DrawText', win, lineBuffer{i}, 100, textYPosition);
            if  textHeight==0
                textRect= Screen('TextBounds', win, lineBuffer{i});
                textHeight= RectHeight(textRect);
            end
            textYPosition= floor(textYPosition + textHeight + 0.2 * textHeight);
        end
        % then display remainder lines.
        if length(charBuffer) > 0;
            %textYPosition= floor(startingYPosition + (i+1) * (textHeight + 0.2 * textHeight));
            Screen('DrawText', win, charBuffer, 100, textYPosition);
        end
        Screen('Flip',  win);
    end
    % Draw the characters...
    Screen('FillRect', win, white);
    % First draw the instructions
    if ~IsLinux
        Screen('TextSize', win, 40);
    end
    %Screen('DrawText', win, 'Fin del test.', 100, 100);
    Screen('Flip', win);
    %WaitSecs(4); % In rapid typing the preceeding message vanishes without a pause here.
    FlushEvents('keyDown');
    Screen('TextSize', win, 20);
    Screen('DrawText', win, 'Aguardar al proximo test.', 100, 250);
    Screen('DrawText', win, 'Presionar una tecla cuando este listo.', 100, 350);
    Screen('Flip', win);
    GetChar;
    Screen('CloseAll');
    
    Screen('CloseAll');
    %esto lo dejo por las dudas
    %Screen('Preference','SkipSyncTests', skipTestFlagOld);
    %Screen('Preference','SuppressAllWarnings', suppressAllWarningsFlagOld);
    %error(lasterr);
    %Screen('Preference','SkipSyncTests', skipTestFlagOld);
    %Screen('Preference','SuppressAllWarnings', suppressAllWarningsFlagOld);
    FlushEvents('keyDown');
    
    
    %fprintf('\n');
    %fprintf('The GetCharTest has reached the end.  Thank you for testing.\n');
    %fprintf('\n');
    
    %Draw i?th image to backbuffer:
    %Screen('DrawTexture', win, textureIndex);
    %Show images exactly 2 refresh cycles apart of each other:
    %[down, secs, keycode]=KbCheck;
    WaitSecs(0.005);
    %Keyboard checks , whatever ... Next loop iteration .
end;
%End of animation loop , blank screen , record offset time :
%toffset = Screen('Flip', win, vbl + (2 - 0.5) * refresh);
toc

Screen('CloseAll');
ShowCursor;
