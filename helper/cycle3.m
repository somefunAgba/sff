function lineH = cycle3(H)
    % cyclestyle.m Cycle line styles.
    % Usage: cyclestyle(handle)
    %
    % Cycles line styles under a handle, H;
    % where H is either an axes or a figure.
    % If no argument is given, H is taken as the current figure.
    %
    % Authors:
    % Oluwasegun Somefun, 21-03-2018.
    % Jyh-Shing Roger Jang, 26-05-1995.
    
    % defined line styles in a n*r character array
    line_style = char('-', '--', '-.');
    
    if nargin == 0
        H = gcf;
    end
    type = H.Type;
    
    if strcmp(type, 'figure')
        % 1. Find all axes objects in the current figure:
        axesH = findobj(H, 'Type', 'axes');

        % disp(axesH)
        % 2. Get the number of axes objects in the current figure:
        axes_num = length(axesH);
        % disp(axes_num)
        for i = 1:axes_num
            
            %  3. Find all line objects in the current axes:
            lineH = findobj(axesH(i), 'Type', 'line');
            % Flip the line objects to start from the
            % first line instead of the last line
            lineH = flipud(lineH);
            % 4. Get the number of line objects in the current axes:
            line_num = length(lineH);
            % disp(line_num)
            
            % cycle through the line-styles in the line-style
            % variable and sets them to each line object
            for j = 1:line_num
                % symmetrically get or cycle through the index of each marker
                % in the line_style char array
                n = rem(j-1, length(line_style)) + 1;
                % disp(n)
                
                % symmetrically set the line-style of each line object to
                % the defined line styles in the line_style variable
                lineH(j).LineStyle = line_style(n, :);
            end
            
        end
    end
    
    if strcmp(type, 'axes')
        %  1. Find all line objects in the current axes:
        lineH = findobj(H, 'Type', 'line');
        % Flip the line objects to start from the
        % first line instead of the last line
        lineH = flipud(lineH);
        % 2. Get the number of line objects in the current axes:
        line_num = length(lineH);
        % disp(line_num)
        
        % cycle through the line-styles in the line-style
        % variable and sets them to each line object
        for j = 1:line_num
            % symmetrically get or cycle through the index of each marker
            % in the line_style char array
            % n = rem(j-1, size(line_style, 1)) or rem(j-1, length(line_style));
            % disp(n)
            lineH(j).LineStyle = line_style(rem(j-1, length(line_style))+1, :);
        end
    end
    
end
