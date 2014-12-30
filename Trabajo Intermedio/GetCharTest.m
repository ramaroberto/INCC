function GetCharTest(startAt)

Screen('FillRect', screenWindow(1), WhiteIndex(screenNumbers(1)));
Screen('DrawText', screenWindow(1), 'This is the typing test.', 100, 100);
Screen('DrawText', screenWindow(1), 'Please type on your keyboard. Use the "Q" key to quit.', 100, 150);
Screen('Flip', screenWindow(1));
FlushEvents('keyDown');
charBuffer='';
stopLoop=0;
lineBuffer={};
totalChars=0;
lineBufferIndex=0;
startingYPosition=200;
textHeight=0;
textYPosition=startingYPosition;
Screen('TextSize', screenWindow(1), 20);
charsPerLine=100;
totalLines=5;
while ~stopLoop
    % Get the character
    c=GetChar;
    totalChars=totalChars+1;
    % test for doneness
    if streq(upper(c), 'Q') || lineBufferIndex > totalLines
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
    Screen('FillRect', screenWindow(1), WhiteIndex(screenNumbers(1)));
    % First draw the instructions
    %Screen('TextSize', screenWindow(1), 40);
    Screen('DrawText', screenWindow(1), 'This is the typing test.', 100, 100);
    Screen('DrawText', screenWindow(1), 'Please type on your keyboard. Use the "Q" key to quit.', 100, 150);
    Screen('TextSize', screenWindow(1), 20);
    % then display full lines...
    textYPosition=startingYPosition;
    for i=1:lineBufferIndex
        Screen('DrawText', screenWindow(1), lineBuffer{i}, 100, textYPosition);
        if  textHeight==0
            textRect= Screen('TextBounds', screenWindow(1), lineBuffer{i});
            textHeight= RectHeight(textRect);
        end
        textYPosition= floor(textYPosition + textHeight + 0.2 * textHeight);
    end
    % then display remainder lines.
    if length(charBuffer) > 0;
        %textYPosition= floor(startingYPosition + (i+1) * (textHeight + 0.2 * textHeight));
        Screen('DrawText', screenWindow(1), charBuffer, 100, textYPosition);
    end
    Screen('Flip',  screenWindow(1));
end
% Draw the characters...
Screen('FillRect', screenWindow(1), WhiteIndex(screenNumbers(1)));
% First draw the instructions
if ~IsLinux
    Screen('TextSize', screenWindow(1), 40);
end
Screen('DrawText', screenWindow(1), 'End of Typing Test.', 100, 100);
Screen('TextSize', screenWindow(1), 20);
Screen('DrawText', screenWindow(1), 'Either you ended the test by typing Q, or you reached the limit of the test.', 100, startingYPosition);
Screen('Flip', screenWindow(1));
WaitSecs(4); % In rapid typing the preceeding message vanishes without a pause here.
FlushEvents('keyDown');
Screen('DrawText', screenWindow(1), 'Press any character key to continue.', 100, startingYPosition);
Screen('Flip', screenWindow(1));
GetChar;
Screen('CloseAll');

Screen('CloseAll');
Screen('Preference','SkipSyncTests', skipTestFlagOld);
Screen('Preference','SuppressAllWarnings', suppressAllWarningsFlagOld);
error(lasterr);
Screen('Preference','SkipSyncTests', skipTestFlagOld);
Screen('Preference','SuppressAllWarnings', suppressAllWarningsFlagOld);
FlushEvents('keyDown');


fprintf('\n');
fprintf('The GetCharTest has reached the end.  Thank you for testing.\n');
fprintf('\n');

% This empty catch block makes sure that the following
% ListenChar(0) command is called in case of error, so Matlab isn't
% left with a dead keyboard.

% Disable listening and flush queue, reenable keyboard dispatching
% to Matlabs windows.
return;

