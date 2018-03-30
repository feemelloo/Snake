function snake
%SOUND
[munch, munch_freq] = audioread('munch.wav');
[death, death_freq] = audioread('death.wav');
[countdown, countdown_freq] = audioread('countdown.wav');
[coin, coin_freq] = audioread('coin.wav');
[tick, tick_freq] = audioread('tick.wav');
%FIGURE
figure('Name', 'Snake', 'NumberTitle', 'off', 'Color', [0 0 0], 'menubar', 'none', 'doublebuffer', 'on', 'KeyPressFcn', @snake_move, 'PointerShapeCData', ones(16, 16) * NaN, 'Pointer', 'custom')
axis([0, 51, 0, 60])
axis square
axis off
%BOARD SETUP
[board_size, board] = board_setup;
cookie_counter = 0;
global key_press
%GAMER TAG
tag_check = false;
options.Interpreter = 'none';
options.WindowStyle = 'normal';
while ~tag_check
    gamer_tag = inputdlg('Gamer tag (5+ characters): ', '', 1, {''}, options);
    if isempty(gamer_tag)
        close(gcf)
        error('No gamer tag chosen')
    end
    gamer_tag = gamer_tag{1};
    if length(gamer_tag) >= 5
        tag_check = true;
    end
end
%SPEED
speed = questdlg('Select a speed', '', 'slug', 'worm', 'python', 'worm');
switch speed
    case 'slug'
        %COUNTDOWN
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '3', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        axis([0, 51, 0, 60])
        axis square
        axis off
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '2', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        axis([0, 51, 0, 60])
        axis square
        axis off
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '1', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        %MOVEMENT
        key_press = 'uparrow';
        key = 'x';
        %TIMER
        time = 0;
        clock = '00:00';
        sec_counter = 0;
        min_counter = 0;
        while ~isempty(key)
            %COOKIES
            if ~any(board == -1)
                cookie_pos = 0;
                while cookie_pos <= board_size ||  cookie_pos > board_size * (board_size - 1) || mod(cookie_pos, board_size) == 0 || mod(cookie_pos - 1, board_size) == 0
                    cookie_pos = randsample(board_size .* board_size, 1);
                end
                board(cookie_pos) = -1;
                cookie_counter = cookie_counter + 1;
            end
                [y_cookie, x_cookie] = find(board == -1);
                plot((51 - board_size) ./ 2 + x_cookie, (51 - board_size) ./ 2 + board_size - y_cookie, 'ks', 'MarkerFaceColor', [1 0.6 0], 'MarkerSize', 4)
                hold on
            %MOVE UP
            if strcmp(key, 'uparrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if mod(head_pos - 1, board_size) == 0 || board(head_pos - 1) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos - 1) == -1
                        board(head_pos - 1) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos - 1) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.1)
                    clf
                end
            %MOVE DOWN
            elseif strcmp(key, 'downarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if mod(head_pos + 1, board_size) == 0 || board(head_pos + 1) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos + 1) == -1
                        board(head_pos + 1) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos + 1) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.1)
                    clf
                end
            %MOVE LEFT
            elseif strcmp(key, 'leftarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if head_pos - board_size < 0 || board(head_pos - board_size) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos - board_size) == -1
                        board(head_pos - board_size) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos - board_size) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.1)
                    clf
                end
            %MOVE RIGHT
            elseif strcmp(key, 'rightarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if head_pos + 2 * board_size > board_size * board_size || board(head_pos + board_size) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos + board_size) == -1
                        board(head_pos + board_size) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos + board_size) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.1)
                    clf
                end
            else
                key = 'uparrow';
                continue
            end
            key = key_press;
            %TIMER
            time = time + 1;
            if mod(time, 10) == 0
                sound(tick, tick_freq);
                sec_counter = sec_counter + 1;
                clock = [num2str(min_counter, '%02i') ':' num2str(sec_counter, '%02i')];
            end
            if sec_counter == 60
                sec_counter = 0;
                min_counter = min_counter + 1;
                clock = [num2str(min_counter, '%02i') ':00'];
            end
        end
    case 'worm'
        %COUNTDOWN
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '3', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        axis([0, 51, 0, 60])
        axis square
        axis off
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '2', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        axis([0, 51, 0, 60])
        axis square
        axis off
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '1', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        %MOVEMENT
        key_press = 'uparrow';
        key = 'x';
        %TIMER
        time = 0;
        clock = '00:00';
        sec_counter = 0;
        min_counter = 0;
        while ~isempty(key)
            %COOKIES
            if ~any(board == -1)
                cookie_pos = 0;
                while cookie_pos <= board_size ||  cookie_pos > board_size * (board_size - 1) || mod(cookie_pos, board_size) == 0 || mod(cookie_pos - 1, board_size) == 0
                    cookie_pos = randsample(board_size .* board_size, 1);
                end
                board(cookie_pos) = -1;
                cookie_counter = cookie_counter + 1;
            end
                [y_cookie, x_cookie] = find(board == -1);
                plot((51 - board_size) ./ 2 + x_cookie, (51 - board_size) ./ 2 + board_size - y_cookie, 'ks', 'MarkerFaceColor', [1 0.6 0], 'MarkerSize', 4)
                hold on
            %MOVE UP
            if strcmp(key, 'uparrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if mod(head_pos - 1, board_size) == 0 || board(head_pos - 1) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos - 1) == -1
                        board(head_pos - 1) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos - 1) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.05)
                    clf
                end
            %MOVE DOWN
            elseif strcmp(key, 'downarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if mod(head_pos + 1, board_size) == 0 || board(head_pos + 1) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos + 1) == -1
                        board(head_pos + 1) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos + 1) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.05)
                    clf
                end
            %MOVE LEFT
            elseif strcmp(key, 'leftarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if head_pos - board_size < 0 || board(head_pos - board_size) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos - board_size) == -1
                        board(head_pos - board_size) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos - board_size) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.05)
                    clf
                end
            %MOVE RIGHT
            elseif strcmp(key, 'rightarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if head_pos + 2 * board_size > board_size * board_size || board(head_pos + board_size) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos + board_size) == -1
                        board(head_pos + board_size) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos + board_size) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.05)
                    clf
                end
            else
                key = 'uparrow';
                continue
            end
            key = key_press;
            %TIMER
            time = time + 0.5;
            if mod(time, 10) == 0
                sound(tick, tick_freq);
                sec_counter = sec_counter + 1;
                clock = [num2str(min_counter, '%02i') ':' num2str(sec_counter, '%02i')];
            end
            if sec_counter == 60
                sec_counter = 0;
                min_counter = min_counter + 1;
                clock = [num2str(min_counter, '%02i') ':00'];
            end
        end
    case 'python'
        %COUNTDOWN
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '3', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        axis([0, 51, 0, 60])
        axis square
        axis off
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '2', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        axis([0, 51, 0, 60])
        axis square
        axis off
        rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
        hold on
        text(ceil(51 ./ 2), ceil(51 ./ 2), '1', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
        sound(countdown, countdown_freq);
        pause(1)
        clf
        %MOVEMENT
        key_press = 'uparrow';
        key = 'x';
        %TIMER
        time = 0;
        clock = '00:00';
        sec_counter = 0;
        min_counter = 0;
        while ~isempty(key)
            %COOKIES
            if ~any(board == -1)
                cookie_pos = 0;
                while cookie_pos <= board_size ||  cookie_pos > board_size * (board_size - 1) || mod(cookie_pos, board_size) == 0 || mod(cookie_pos - 1, board_size) == 0
                    cookie_pos = randsample(board_size .* board_size, 1);
                end
                board(cookie_pos) = -1;
                cookie_counter = cookie_counter + 1;
            end
                [y_cookie, x_cookie] = find(board == -1);
                plot((51 - board_size) ./ 2 + x_cookie, (51 - board_size) ./ 2 + board_size - y_cookie, 'ks', 'MarkerFaceColor', [1 0.6 0], 'MarkerSize', 4)
                hold on
            %MOVE UP
            if strcmp(key, 'uparrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if mod(head_pos - 1, board_size) == 0 || board(head_pos - 1) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos - 1) == -1
                        board(head_pos - 1) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos - 1) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.02)
                    clf
                end
            %MOVE DOWN
            elseif strcmp(key, 'downarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if mod(head_pos + 1, board_size) == 0 || board(head_pos + 1) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos + 1) == -1
                        board(head_pos + 1) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos + 1) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.02)
                    clf
                end
            %MOVE LEFT
            elseif strcmp(key, 'leftarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if head_pos - board_size < 0 || board(head_pos - board_size) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos - board_size) == -1
                        board(head_pos - board_size) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos - board_size) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.02)
                    clf
                end
            %MOVE RIGHT
            elseif strcmp(key, 'rightarrow')
                head_val = max(max(board));
                head = board == max(max(board));
                head_pos = find(head);
                body = board > 0;
                if head_pos + 2 * board_size > board_size * board_size || board(head_pos + board_size) > 0
                    clf
                    text(26, 26, 'GAME OVER', 'FontName', 'Pixeled', 'FontSize', 30, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    sound(death, death_freq)
                    list = leaderboard('leaderboard.xlsx', upper(gamer_tag), cookie_counter);
                    pause(1.5)
                    clf
                    text(26, 51, 'LEADERBOARD', 'FontName', 'Pixeled', 'FontSize', 25, 'Color', 'g', 'HorizontalAlignment', 'center')
                    sound(coin, coin_freq)
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    hold on
                    pause(0.2)
                    text(26, 35, sprintf('1. %s: %d', list{2, 1}, list{2, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 25, sprintf('2. %s: %d', list{3, 1}, list{3, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(0.2)
                    text(26, 15, sprintf('3. %s: %d', list{4, 1}, list{4, 2}), 'FontName', 'Pixeled', 'FontSize', 17, 'Color', 'g', 'HorizontalAlignment', 'center')
                    pause(2)
                    close(gcf)
                    break
                else
                    if board(head_pos + board_size) == -1
                        board(head_pos + board_size) = head_val + 1;
                        sound(munch, munch_freq);
                    else
                        board(body) = board(body) - 1;
                        board(head_pos + board_size) = head_val;
                    end
                    [y_pos, x_pos] = find(board > 0);
                    plot((51 - board_size) ./ 2 + x_pos, (51 - board_size) ./ 2 + board_size - y_pos, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
                    hold on
                    text((51 - board_size) ./ 2 + 10, (51 - board_size) ./ 2 + 2 + board_size, sprintf('cookies: %d', cookie_counter), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    text((51 - board_size) ./ 2 + board_size, (51 - board_size) ./ 2 + 2 + board_size, sprintf('%s', clock), 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'right')
                    rectangle('Position', [(51 - board_size) ./ 2, (51 - board_size) ./ 2, board_size, board_size], 'EdgeColor','w')
                    axis([0, 51, 0, 60])
                    axis square
                    axis off
                    pause(0.02)
                    clf
                end
            else
                key = 'uparrow';
                continue
            end
            key = key_press;
            %TIMER
            time = time + 0.2;
            if mod(time, 10) == 0
                sound(tick, tick_freq);
                sec_counter = sec_counter + 1;
                clock = [num2str(min_counter, '%02i') ':' num2str(sec_counter, '%02i')];
            end
            if sec_counter == 60
                sec_counter = 0;
                min_counter = min_counter + 1;
                clock = [num2str(min_counter, '%02i') ':00'];
            end
        end
end
if isempty(board_size)
    close(gcf)
    error('No speed chosen')
end
end

function [board_size, board] = board_setup
set(0, 'DefaultUicontrolFontWeight', 'bold')
set(0,'DefaultImageVisible','off')
board_size = questdlg('Select a board size', '', 'small', 'medium', 'large', 'large');
switch board_size
    case 'small'
        board_size = 21;
    case 'medium'
        board_size = 31;
    case 'large'
        board_size = 51;
end
if isempty(board_size)
    close(gcf)
    error('No board size chosen')
end
board = zeros(board_size, board_size);
board(board_size .* ceil(board_size ./ 2) - floor(board_size ./ 2) + 1) = 1;
board(board_size .* ceil(board_size ./ 2) - floor(board_size ./ 2)) = 2;
board(board_size .* ceil(board_size ./ 2) - ceil(board_size ./ 2)) = 3;
pos = 1:board_size * board_size;
snake_mask = pos == board_size .* ceil(board_size ./ 2) - floor(board_size ./ 2) + 1 | pos == board_size .* ceil(board_size ./ 2) - floor(board_size ./ 2) | pos == board_size .* ceil(board_size ./ 2) - ceil(board_size ./ 2);
pos(snake_mask) = [];
cookie_pos = pos(randi([1, board_size .* board_size - 3], 1));
board(cookie_pos) = -1;
end

function [raw] = leaderboard (list, tag, score)
[~, ~, raw] = xlsread(list);
[rows, cols] = size(raw);
add = true;
for r = 2:rows
    if strcmp(raw{r, 1}, tag)
        add = false;
        if score > raw{r, 2}
            raw{r, 2} = score;
        end
        break
    end
end
if add
    raw{rows + 1, 1} = tag;
    raw{rows + 1, 2} = score;
end
[~, order] = sort([raw{2:end, 2}], 'descend');
for c = 1:cols
    raw(2:end, c) = raw(order + 1, c);
end
xlswrite(list, raw);
file = fopen('leaderboard.txt', 'w');
if add
    for t = 2:rows + 1
        fprintf(file, '%s, %d\r\n',raw{t,:});
    end
else
    for t = 2:rows
        fprintf(file, '%s, %d\r\n',raw{t,:});
    end
end
fclose(file);
end

function snake_move (~, key_handle)
global key_press
key_press = key_handle.Key;
end