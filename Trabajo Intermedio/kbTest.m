% ------------------------------------------ %
% -------------- Configuracion ------------- %
% ------------------------------------------ %

% Configuracion de pantalla
res = [1281 800];
screenNum = 0;
clrdepth = 32;

wait_pl1 = 0.5;  % Tiempo que dura la primer pantalla para limpiar retina
wait_is = 2;   % Tiempo que se muestra la imagen subliminal
wait_pl2 = 0.5;  % Tiempo que dura la segunda pantalla para limpiar retina

% Cantidad de brillo agregado a la imagen subliminal
% Con 0 <= bright_intensity < 1. 0 = imagen normal, 0.99 = imagen blanca. 
bright_intensity = 0.5;

% Tamanio en pixels para los espacios horizontales entre las imagenes secundarias
imgsec_space = 100;

% Maximo tamanio para la imagen subliminal
sub_bounds = res*(1/2);

% Maximo tamanio para imagenes secundarias (sin concatenar)
sec_bounds = [res(1) (res(2)*(1/2))];

% Maximo tamanio para imagenes secundarias concatenadas
conc_sec_bounds = res*(9/10);

% Teclas validas
valid_keys = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

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
    keyIsDown = false;
    wasPressed = false;
    while ~wasPressed || keyIsDown
        if ~wasPressed
            [keyIsDown, ~, keyCode, ~] = KbCheck();
            if keyIsDown
                wasPressed = true;
            end
        else
            [keyIsDown, ~, ~, ~] = KbCheck();
        end
    end
    c = KbName(keyCode);

    % Si apreto enter, terminamos.
    if streq(c, 'return')
        break;
    end
    
    % Si no es un caracter valido lo dejamos como vacio.
    if size(c, 2)== 1 && ismember(c, valid_keys)
        totalChars = totalChars+1;
    else
        c = '';
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

charBuffer

Screen('CloseAll');
ShowCursor;