% ------------------------------------------ %
% -------------- Configuracion ------------- %
% ------------------------------------------ %

% Configuracion de pantalla
res = [1281 800];
screenNum = 0;
clrdepth = 32;

wait_pl1 = 1;  % Tiempo que dura la primer pantalla para limpiar retina
wait_is = 2;   % Tiempo que se muestra la imagen subliminal
wait_pl2 = 2;  % Tiempo que dura la segunda pantalla para limpiar retina

% Cantidad de brillo agregado a la imagen subliminal
qlight = 1;

% Tamanio en pixels para los espacios horizontales entre las imagenes secundarias
imgsec_space = 100;

% Maximo tamanio para la imagen subliminal
sub_bounds = res*(1/2);

% Maximo tamanio para imagenes secundarias (sin concatenar)
sec_bounds = [res(1) (res(2)*(1/2))];

% Maximo tamanio para imagenes secundarias concatenadas
conc_sec_bounds = res*(9/10);

% ------------------------------------------ %
% ------------- Inicializacion ------------- %
% ------------------------------------------ %

% Inicializacion de pantalla
width = res(1);
height = res(2);
Screen('Preference', 'SkipSyncTests', 1);
[win,rect]=Screen('OpenWindow',screenNum,0,[0 0 res(1) res(2)], clrdepth);

% Definimos colores y hacemos el primer flip
black = BlackIndex(win);
white = WhiteIndex (win) ;
Screen('FillRect',win,black);
refresh = Screen('GetFlipInterval',win);
vbl = Screen('Flip', win);

% ------------------------------------------ %
% ------------ Carga de imagenes ----------- %
% ------------------------------------------ %

% Recorremos el directorio imgs y armamos los vectores
[imagenesSubliminales, imagenesSecundarias, etiquetas] = getImgsPaths('imgs');

% Sacamos exactamente n/4 pares de numeros sin reposicion.
pairs = datasample(1:size(imagenesSubliminales, 1), floor(size(imagenesSubliminales, 1)/4)*2, 'Replace', false);

% Preparamos un vector vertical de bools para saber cuales cambiamos
fruit = cell(size(imagenesSubliminales, 1), 1);
[fruit{:}] = deal(0);
 
% Intercambiamos los valores entre pares, de forma tal de generar frula.
base = floor(size(pairs,2)/2);
for i = 1:base
    aux = imagenesSubliminales{pairs(i)};
    imagenesSubliminales{pairs(i)} = imagenesSubliminales{pairs(base+i)};
    imagenesSubliminales{pairs(base+i)} = aux;
    fruit{pairs(i)} = 1;
    fruit{pairs(base+i)} = 1;
end

% El try-catch-end es para evitar que quede colgado en caso de excepcion.
try

    % ------------------------------------------ %
    % ------------- Instrucciones -------------- %
    % ------------------------------------------ %

    Screen('FillRect', win, white);
    Screen('TextStyle', win, 1);
    Screen('TextSize',win, 30);
    Screen('TextFont',win, 'Helvetica');

    Screen('DrawText', win, 'A continuacion apareceran grupos de 3 imagenes.', 280, 250, [0 1 1], [0, 0, 255, 255]);
    Screen('DrawText', win, 'La tarea consiste en escribir una palabra que se relacione con ellas.', 130, 350, [0 1 1], [0, 0, 255, 255]);
    Screen('DrawText', win, 'Debera oprimir la barra espaciadora recien cuando este listo para escribir la palabra.', 30, 450, [0 1 1], [0, 0, 255, 255]);

    Screen('TextSize',win, 50);
    Screen('DrawText', win, 'Presione una tecla para continuar...', 220, 650, [0 1 1], [0, 0, 255, 255]);
    Screen('Flip', win);

    % Esperamos hasta que el usuario presione una tecla
    KbWait;
    
    % Preparamos el arreglo donde guardamos los datos
    data = [];
    
    % Desordenamos el orden de las imagenes
    ord = 1:size(imagenesSubliminales,1);
    ord = ord(randperm(length(ord)));
    
    
    i = 0;
    % TODO: Descomentar cuando terminemos de testear 
    % for i = 1:size(imagenesSubliminales,1)
    for j=1:3
        
        % Usamos como indice el orden aleatorio
        i = ord(j);
        
        % ------------------------------------------ %
        % ----------- Imagen subliminal ------------ %
        % ------------------------------------------ %

        % Cargamos, aclaramos y mostramos la imagen
        imsub = imgLoadAndResize(imagenesSubliminales{i}, sub_bounds);
        Screen('PutImage', win, imsub);
        Screen('Flip', win);

        % La mostramos por wait_is segundos
        WaitSecs(wait_is);

        % Mostrar ruido para limpiar la retina
        whiteNoiseScreen(win, rect, 5, 1281);

        % ------------------------------------------ %
        % ---------- Imagenes secundarias ---------- %
        % ------------------------------------------ %

        % Cargamos las imagenes
        imsec1 = imgLoadAndResize(imagenesSecundarias{i,1}, sec_bounds);
        imsec2 = imgLoadAndResize(imagenesSecundarias{i,2}, sec_bounds);
        imsec3 = imgLoadAndResize(imagenesSecundarias{i,3}, sec_bounds);

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
        imsecs=imgLoadAndResize('', conc_sec_bounds, [imsec1 space imsec2 space imsec3]);

        % Ponemos en pantalla y mostramos
        Screen('PutImage', win, imsecs);
        Screen('TextSize',win, 20);
        Screen('DrawText', win, 'Presione la barra de espacio cuando este listo para escribir la palabra...', 300, 700, [0 1 1], [0, 0, 255, 255]);
        Screen('DrawText', win, 'y comience a escribir', 500, 750, [0 1 1], [0, 0, 255, 255]);
        Screen('Flip', win);

        % Esperamos hasta que el usuario toque una tecla
        tic;
        pressed = 0;
        while pressed == 0
            [pressed, secs, kbData] = KbCheck;
        end;
        
        % Guardamos el tiempo que tardo en hacerlo
        time = toc;

        % ------------------------------------------ %
        % ---------- Escribir la palabra ----------- %
        % ------------------------------------------ %

        % Mensaje de continuacion
        Screen('FillRect', win, white);
        Screen('DrawText', win, 'Ingresar una unica palabra. Apriete la barra espaciadora cuando haya terminado.', 100, 150);
        Screen('TextSize', win, 20);
        Screen('Flip', win);

        % Habilitamos la escritura
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
            % Obtenemos el caracter
            c=GetChar;
            totalChars=totalChars+1;

            % Si apreto la barra espaciadora, terminamos.
            if streq(upper(c), ' ') || lineBufferIndex > totalLines
                break;
            end

            % Guardamos el caracter
            charBuffer = [charBuffer c];

            % Instrucciones
            Screen('FillRect', win, white);
            Screen('DrawText', win, 'Ingresar una unica palabra. Apriete la barra espaciadora cuando haya terminado.', 100, 150);
            Screen('TextSize', win, 20);

            % Dibujamos los caracteres ingresados hasta el momento
            textYPosition=startingYPosition;
            for z=1:lineBufferIndex
                Screen('DrawText', win, lineBuffer{z}, 100, textYPosition);
                if  textHeight==0
                    textRect= Screen('TextBounds', win, lineBuffer{z});
                    textHeight= RectHeight(textRect);
                end
                textYPosition= floor(textYPosition + textHeight + 0.2 * textHeight);
            end
            if length(charBuffer) > 0;
                Screen('DrawText', win, charBuffer, 100, textYPosition);
            end
            Screen('Flip',  win);
        end
        
        % ------------------------------------------ %
        % ------- Guardamos datos obtenidos -------- %
        % ------------------------------------------ %
        
        data = [data; [i {etiquetas{i} fruit{i} time charBuffer}]];

        % ------------------------------------------ %
        % --------- Siguiente experimento ---------- %
        % ------------------------------------------ %

        % Imprimimos instrucciones.
        FlushEvents('keyDown');
        Screen('FillRect', win, white);
        Screen('TextSize', win, 20);
        Screen('DrawText', win, 'Aguardar al proximo test.', 100, 250);
        Screen('DrawText', win, 'Presionar una tecla cuando este listo.', 100, 350);
        Screen('Flip', win);

        % Esperamos que presione alguna tecla
        GetChar;
        FlushEvents('keyDown');
        WaitSecs(0.005);

    end;

% El try-catch-end es para evitar que quede colgado en caso de excepcion.
catch e
    e
    e.stack.file
    e.stack.name
    e.stack.line
end

Screen('CloseAll');
ShowCursor;

% ------------------------------------------ %
% ------------- Exportar datos ------------- %
% ------------------------------------------ %

% Te odio matlab... ordenamos los datos por el identificador.
for i=1:size(data,1)
    for j=(i+1):size(data,1)
        if data{j,1} < data{i,1}
            aux = data(i, 1:end);
            data(i, 1:end) = data(j, 1:end);
            data(j, 1:end) = aux;
        end
    end
end

% Exportamos
data

%Sabri: Esto lo dejo por las dudas
%Screen('Preference','SkipSyncTests', skipTestFlagOld);
%Screen('Preference','SuppressAllWarnings', suppressAllWarningsFlagOld);
%error(lasterr);
%Screen('Preference','SkipSyncTests', skipTestFlagOld);
%Screen('Preference','SuppressAllWarnings', suppressAllWarningsFlagOld);    

%fprintf('\n');
%fprintf('The GetCharTest has reached the end.  Thank you for testing.\n');
%fprintf('\n');

%Draw i?th image to backbuffer:
%Screen('DrawTexture', win, textureIndex);
%Show images exactly 2 refresh cycles apart of each other:
%[down, secs, keycode]=KbCheck;
%Keyboard checks , whatever ... Next loop iteration .
