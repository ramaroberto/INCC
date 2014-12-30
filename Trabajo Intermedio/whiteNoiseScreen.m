function [updaterate] = whiteNoiseScreen(win, winRect, nframes, rectSize, numRects, scale, syncToVBL, dontclear)

updaterate = 0;

if nargin < 2
    error('win and winRect parameters are mandatory.');
end

if nargin < 3 || isempty(nframes)
    nframes = 50; % Default patch size is 128 by 128 noisels.
end

if nargin < 4 || isempty(rectSize)
    rectSize = 100; % Default patch size is 128 by 128 noisels.
end

if nargin < 5 || isempty(numRects)
    numRects = 1; % Draw one noise patch by default.
end

if nargin < 6 || isempty(scale)
    scale = 1; % Don't up- or downscale patch by default.
end

if nargin < 7 || isempty(syncToVBL)
    syncToVBL = 1; % Synchronize to vertical retrace by default.
end

if syncToVBL > 0
    asyncflag = 0;
else
    asyncflag = 2;
end

if nargin < 8 || isempty(dontclear)
    dontclear = 0; % Clear backbuffer to background color by default after each bufferswap.
end

if dontclear > 0
    % A value of 2 will prevent any change to the backbuffer after a
    % bufferswap. In that case it is your responsibility to take care of
    % that, but you'll might save up to 1 millisecond.
    dontclear = 2;
end

try
    % Find screen with maximal index:
    %screenid = max(Screen('Screens'));

    % Open fullscreen onscreen window on that screen. Background color is
    % gray, double buffering is enabled. Return a 'win'dowhandle and a
    % rectangle 'winRect' which defines the size of the window:
    %[win, winRect] = Screen('OpenWindow', screenid, 128);
        
    % Compute destination rectangle locations for the random noise patches:
    
    % 'objRect' is a rectangle of the size 'rectSize' by 'rectSize' pixels of
    % our Matlab noise image matrix:
    objRect = SetRect(0,0, rectSize, rectSize);

    % ArrangeRects creates 'numRects' copies of 'objRect', all nicely
    % arranged / distributed in our window of size 'winRect':
    dstRect = ArrangeRects(numRects, objRect, winRect);

    % Now we rescale all rects: They are scaled in size by a factor 'scale':
    for i=1:numRects
        % Compute center position [xc,yc] of the i'th rectangle:
        [xc, yc] = RectCenter(dstRect(i,:));
        % Create a new rectange, centered at the same position, but 'scale'
        % times the size of our pixel noise matrix 'objRect':
        dstRect(i,:)=CenterRectOnPoint(objRect * scale, xc, yc);
    end

    % Init framecounter to zero and take initial timestamp:
    count = 0;    
    tstart = GetSecs;

    % Run noise image drawing loop for 1000 frames:
    while count < nframes
        % Generate and draw 'numRects' noise images:
        for i=1:numRects
            % Compute noiseimg noise image matrix with Matlab:
            % Normally distributed noise with mean 128 and stddev. 50, each
            % pixel computed independently:
            noiseimg=(50*randn(rectSize, rectSize) + 128);

            % Convert it to a texture 'tex':
            tex=Screen('MakeTexture', win, noiseimg);

            % Draw the texture into the screen location defined by the
            % destination rectangle 'dstRect(i,:)'. If dstRect is bigger
            % than our noise image 'noiseimg', PTB will automatically
            % up-scale the noise image. We set the 'filterMode' flag for
            % drawing of the noise image to zero: This way the bilinear
            % filter gets disabled and replaced by standard nearest
            % neighbour filtering. This is important to preserve the
            % statistical independence of the noise pixels in the noise
            % texture! The default bilinear filtering would introduce local
            % correlations when scaling is applied:
            Screen('DrawTexture', win, tex, [], dstRect(i,:), [], 0);

            % After drawing, we can discard the noise texture.
            Screen('Close', tex);
        end
        
        % Done with drawing the noise patches to the backbuffer: Initiate
        % buffer-swap. If 'asyncflag' is zero, buffer swap will be
        % synchronized to vertical retrace. If 'asyncflag' is 2, bufferswap
        % will happen immediately -- Only useful for benchmarking!
        Screen('Flip', win, 0, dontclear, asyncflag);

        % Increase our frame counter:
        count = count + 1;
    end

    % We're done: Output average framerate:
    telapsed = GetSecs - tstart;
    updaterate = count / telapsed;
    
    % Done. Close Screen, release all ressouces:
    %Screen('CloseAll');
catch
    % Our usual error handler: Close screen and then...
    Screen('CloseAll');
    % ... rethrow the error.
    psychrethrow(psychlasterror);
end
