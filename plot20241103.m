% 对应文件为quad_ETC_20240612
close all;


%% 绘制领导者和跟随者的位置信息 x1, x2, x3
% 提取时间数据和位置数据
size_t = size(out.tout, 1);
tout = out.tout;

% 读取领导者和跟随者的位置数据
ori.pos_l = out.pos(:, 1:3);
ori.pos_f1 = out.pos(:, 7:9);
ori.pos_f2 = out.pos(:, 13:15);
ori.pos_f3 = out.pos(:, 19:21);
ori.pos_f4 = out.pos(:, 25:27);
ori.pos_f5 = out.pos(:, 31:33);

% 定义位置偏移（这里设置为零）
offset.f1 = 0.00 * [5 * ones(size_t, 1), zeros(size_t, 1), zeros(size_t, 1)];
offset.f2 = 0.00 * [1.5451 * ones(size_t, 1), 4.7553 * ones(size_t, 1), zeros(size_t, 1)];
offset.f3 = 0.00 * [-4.0451 * ones(size_t, 1), 2.9389 * ones(size_t, 1), zeros(size_t, 1)];
offset.f4 = 0.00 * [-4.0451 * ones(size_t, 1), -2.9389 * ones(size_t, 1), zeros(size_t, 1)];
offset.f5 = 0.00 * [1.5451 * ones(size_t, 1), -4.7553 * ones(size_t, 1), zeros(size_t, 1)];

% 应用偏移量
off.pos_f1 = ori.pos_f1 + offset.f1;
off.pos_f2 = ori.pos_f2 + offset.f2;
off.pos_f3 = ori.pos_f3 + offset.f3;
off.pos_f4 = ori.pos_f4 + offset.f4;
off.pos_f5 = ori.pos_f5 + offset.f5;

% 整理所有位置数据，每个元素包含所有智能体在某个坐标轴的位置信息
pos_x = [ori.pos_l(:, 1), off.pos_f1(:, 1), off.pos_f2(:, 1), off.pos_f3(:, 1), off.pos_f4(:, 1), off.pos_f5(:, 1)];
pos_y = [ori.pos_l(:, 2), off.pos_f1(:, 2), off.pos_f2(:, 2), off.pos_f3(:, 2), off.pos_f4(:, 2), off.pos_f5(:, 2)];
pos_z = [ori.pos_l(:, 3), off.pos_f1(:, 3), off.pos_f2(:, 3), off.pos_f3(:, 3), off.pos_f4(:, 3), off.pos_f5(:, 3)];

% 创建包含所有坐标轴数据的 cell 数组
pos_matrix = {pos_x, pos_y, pos_z};
coord_labels = {'x/m', 'y/m', 'z/m'};  % 坐标轴标签



% 主图设置
figure(5);
set(gcf, 'unit', 'centimeters', 'position', [0.5 0.5 15.5 14]);  % 设置图形窗口大小
set(gca, 'LooseInset', [0, 0, 0, 0]);

% 布局参数设置
nRows = length(pos_matrix);     % 子图的行数（即3个坐标轴）
subPlotSpacing = 0.04;          % 子图之间的垂直间距
subPlotMarginLeft = 0.085;      % 左边距
subPlotMarginRight = 0.020;     % 右边距
subPlotBottom = 0.075;          % 底边距

% 添加顶边距和图例高度
topMargin = 0.020;              % 顶边距
legendHeight = 0.035;           % 图例区域高度

% 计算子图顶部位置
subPlotTop = 1 - topMargin - legendHeight - subPlotSpacing;

% 计算子图的总高度和每个子图的高度
totalHeight = subPlotTop - subPlotBottom - (nRows - 1) * subPlotSpacing;
subPlotHeight = totalHeight / nRows;

% 定义智能体标签
agent_labels = {'Leader', 'Follower 1', 'Follower 2', 'Follower 3', 'Follower 4', 'Follower 5'};

% 绘制每个坐标轴的数据
for i = 1:nRows
    % 计算子图的位置
    bottomPos = subPlotBottom + (nRows - i) * (subPlotHeight + subPlotSpacing);
    
    % 创建主子图
    subplot('Position', [subPlotMarginLeft, bottomPos, 1 - subPlotMarginLeft - subPlotMarginRight, subPlotHeight]);
    hold on;
    pos_data = pos_matrix{i};  % 当前坐标轴的数据
    box on;
    
    % 绘制领导者和跟随者的位置曲线，并设置 'DisplayName' 属性
    p1 = plot(tout, pos_data(:, 1), 'k-', 'LineWidth', 1.5, 'DisplayName', 'Leader');       % Leader
    p2 = plot(tout, pos_data(:, 2), 'r:', 'LineWidth', 1.5, 'DisplayName', 'Follower 1');   % Follower 1
    p3 = plot(tout, pos_data(:, 3), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Follower 2');  % Follower 2
    p4 = plot(tout, pos_data(:, 4), 'm-.', 'LineWidth', 1.5, 'DisplayName', 'Follower 3');  % Follower 3
    p5 = plot(tout, pos_data(:, 5), 'r-.', 'LineWidth', 1.5, 'DisplayName', 'Follower 4');  % Follower 4
    p6 = plot(tout, pos_data(:, 6), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Follower 5');   % Follower 5

    % 设置图例，仅在第一个子图中显示
    if i == 1
        lgd = legend([p1, p2, p3, p4, p5, p6]);
        set(lgd, 'NumColumns', 3);  % 设置图例为两行显示
        % 调整图例位置
        lgd.Position = [0.5 - lgd.Position(3)/2, 1 - topMargin - lgd.Position(4), lgd.Position(3), lgd.Position(4)];
        set(lgd, 'Orientation', 'horizontal', 'FontSize', 10.5);
    end

    ylabel(coord_labels{i});  % 设置 y 轴标签，去除 "position"
    if i == nRows
        xlabel('Time (s)');    % 仅在最后一个子图中设置 x 轴标签
    end

    % 获取当前 y 轴范围
    yl = ylim;
    
    % 定义需要标记的时间区间
    rest_intervals = [15 20; 45 55; 150 170; 200 220];
    
    % 在指定的时间区间添加灰色透明区域和竖直虚线
    for j = 1:size(rest_intervals, 1)
        x1 = rest_intervals(j, 1);
        x2 = rest_intervals(j, 2);
    
        % 添加灰色透明填充区域，使用 patch 并设置 'HandleVisibility' 为 'off'
        patch('XData', [x1 x2 x2 x1], 'YData', [yl(1) yl(1) yl(2) yl(2)], ...
              'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.2, 'HandleVisibility', 'off');
        
        % 添加竖直虚线，并设置 'HandleVisibility' 为 'off'
        plot([x1 x1], yl, 'k--', 'LineWidth', 1.0, 'HandleVisibility', 'off');
        plot([x2 x2], yl, 'k--', 'LineWidth', 1.0, 'HandleVisibility', 'off');
    end
    
    % 恢复原始的 y 轴范围，防止因添加元素而改变
    ylim(yl);

    % 设置坐标轴刻度标签使用 LaTeX 解释器，并替换负号
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    ax.XTickLabel = strrep(ax.XTickLabel, '-', '$-$');
    ax.YTickLabel = strrep(ax.YTickLabel, '-', '$-$');
end

% 全局字体和样式设置
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 10.5);
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Times New Roman');

% 保存图形
saveas(gcf, '.\figure\positions.png');







%% 绘制三维轨迹
size_t = size(out.tout,1);
tout = out.tout;

% 读取领导者和跟随者的位置数据
ori.pos_l = out.pos(:,1:3);
ori.pos_f1 = out.pos(:,7:9);
ori.pos_f2 = out.pos(:,13:15);
ori.pos_f3 = out.pos(:,19:21);
ori.pos_f4 = out.pos(:,25:27);
ori.pos_f5 = out.pos(:,31:33);

offset.f1 = 0.25*[5*ones(size_t,1), 0*ones(size_t,1), zeros(size_t,1)];
offset.f2 = 0.25*[1.5451*ones(size_t,1), 4.7553*ones(size_t,1), zeros(size_t,1)];
offset.f3 = 0.25*[-4.0451*ones(size_t,1), 2.9389*ones(size_t,1), zeros(size_t,1)];
offset.f4 = 0.25*[-4.0451*ones(size_t,1), -2.9389*ones(size_t,1), zeros(size_t,1)];
offset.f5 = 0.25*[1.5451*ones(size_t,1), -4.7553*ones(size_t,1), zeros(size_t,1)];

off.pos_f1 = ori.pos_f1 + offset.f1;
off.pos_f2 = ori.pos_f2 + offset.f2;
off.pos_f3 = ori.pos_f3 + offset.f3;
off.pos_f4 = ori.pos_f4 + offset.f4;
off.pos_f5 = ori.pos_f5 + offset.f5;

% 计算特定时间点的索引，包括0时刻
time_points = [0, 50, 100, 150, 200, 250];  % 假设tout单位为秒
indices = arrayfun(@(t) find(tout >= t, 1, 'first'), time_points);

% 绘制三维轨迹
figure(1);
hold on;
box on;

plot3(ori.pos_l(:,1), ori.pos_l(:,2), ori.pos_l(:,3), 'k--', 'LineWidth', 1);
plot3(off.pos_f1(:,1), off.pos_f1(:,2), off.pos_f1(:,3), 'r--', 'LineWidth', 1);
plot3(off.pos_f2(:,1), off.pos_f2(:,2), off.pos_f2(:,3), 'g--', 'LineWidth', 1);
plot3(off.pos_f3(:,1), off.pos_f3(:,2), off.pos_f3(:,3), 'b--', 'LineWidth', 1);
plot3(off.pos_f4(:,1), off.pos_f4(:,2), off.pos_f4(:,3), 'c--', 'LineWidth', 1);
plot3(off.pos_f5(:,1), off.pos_f5(:,2), off.pos_f5(:,3), 'm--', 'LineWidth', 1);

% 在0时刻和特定时间点标记领导者和跟随者的位置
leader_symbol = 'h';  % 领导者的标记形状
follower_symbols = {'o', 's', '^', 'd', 'p', 'v'};  % 跟随者的标记形状
for i = 1:length(time_points)
    idx = indices(i);
    scatter3(ori.pos_l(idx,1), ori.pos_l(idx,2), ori.pos_l(idx,3), 120, 'k', leader_symbol, 'filled');
    scatter3(off.pos_f1(idx,1), off.pos_f1(idx,2), off.pos_f1(idx,3), 100, 'r', follower_symbols{i}, 'filled');
    scatter3(off.pos_f2(idx,1), off.pos_f2(idx,2), off.pos_f2(idx,3), 100, 'g', follower_symbols{i}, 'filled');
    scatter3(off.pos_f3(idx,1), off.pos_f3(idx,2), off.pos_f3(idx,3), 100, 'b', follower_symbols{i}, 'filled');
    scatter3(off.pos_f4(idx,1), off.pos_f4(idx,2), off.pos_f4(idx,3), 100, 'c', follower_symbols{i}, 'filled');
    scatter3(off.pos_f5(idx,1), off.pos_f5(idx,2), off.pos_f5(idx,3), 100, 'm', follower_symbols{i}, 'filled');
end

% 在特定时间点连接所有跟随者
for i = 1:length(indices)
    idx = indices(i);
    x = [off.pos_f1(idx,1), off.pos_f2(idx,1), off.pos_f3(idx,1), off.pos_f4(idx,1), off.pos_f5(idx,1), off.pos_f1(idx,1)];
    y = [off.pos_f1(idx,2), off.pos_f2(idx,2), off.pos_f3(idx,2), off.pos_f4(idx,2), off.pos_f5(idx,2), off.pos_f1(idx,2)];
    z = [off.pos_f1(idx,3), off.pos_f2(idx,3), off.pos_f3(idx,3), off.pos_f4(idx,3), off.pos_f5(idx,3), off.pos_f1(idx,3)];
    plot3(x, y, z, 'k-', 'LineWidth', 1.5);
    if i == 1
        text(mean(x), mean(y) - 1.2 , mean(z), ['t=' num2str(time_points(i)) 's'], 'FontSize', 10.5, 'HorizontalAlignment', 'center');  % 添加五边形连线的时间标签
    elseif i == 2
        text(mean(x), mean(y) - 0.65, mean(z), ['t=' num2str(time_points(i)) 's'], 'FontSize', 10.5, 'HorizontalAlignment', 'center');  % 添加五边形连线的时间标签
    elseif i == 3
        text(mean(x), mean(y) + 0.65, mean(z), ['t=' num2str(time_points(i)) 's'], 'FontSize', 10.5, 'HorizontalAlignment', 'center');  % 添加五边形连线的时间标签
    elseif i == 4
        text(mean(x), mean(y) + 0.65, mean(z), ['t=' num2str(time_points(i)) 's'], 'FontSize', 10.5, 'HorizontalAlignment', 'center');  % 添加五边形连线的时间标签
    elseif i ==5
       	text(mean(x), mean(y) + 0.65, mean(z), ['t=' num2str(time_points(i)) 's'], 'FontSize', 10.5, 'HorizontalAlignment', 'center');  % 添加五边形连线的时间标签
    else
        text(mean(x), mean(y) + 0.65, mean(z), ['t=' num2str(time_points(i)) 's'], 'FontSize', 10.5, 'HorizontalAlignment', 'center');  % 添加五边形连线的时间标签
    end
end

% 观察角度调整
view(3);  % 自动调整为最佳三维视角

xlabel('X/m');
ylabel('Y/m');
zlabel('Z/m');

% 设置坐标轴刻度标签使用 LaTeX 解释器，并替换负号
ax = gca;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = strrep(ax.XTickLabel, '-', '$-$');
ax.YTickLabel = strrep(ax.YTickLabel, '-', '$-$');


% 设置图例位置
lgd = legend('Leader', 'Follower 1', 'Follower 2', 'Follower 3', 'Follower 4', 'Follower 5', 'Location', 'southwest');
lgd_pos = get(lgd, 'Position');
new_lgd_pos = [0.71, 0.235, lgd_pos(3), lgd_pos(4)];  % 调整图例位置，使其稍微离开左下角
set(lgd, 'Position', new_lgd_pos);

% 设置图形尺寸和字体属性
set(gcf,'unit','centimeters','position',[5 5 16.5 12.5]);
set(gca,'LooseInset',[0,0,0,0]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10.5);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 10.5);
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Times New Roman');

hold off;
saveas(gcf,'.\figure\quad_position.png');































%% 一致性误差
% 提取数据
size_t = size(out.tout,1);  % 获取时间数据的大小
tout = out.tout;            % 提取时间数据
q1 = out.q(:,1:6);          % 提取q1数据
q2 = out.q(:,7:12);         % 提取q2数据
q3 = out.q(:,13:18);        % 提取q3数据
q4 = out.q(:,19:24);        % 提取q4数据
q5 = out.q(:,25:30);        % 提取q5数据
q6 = out.q(:,31:36);        % 提取q6数据

% 设置图形尺寸和位置
figure(2);
set(gcf, 'unit', 'centimeters', 'position', [0.5 0.5 16 18]);  % 设置图形的大小和位置
set(gca,'LooseInset',[0,0,0,0]);  % 去除图形周围多余的空白边距

% 准备数据
q_matrix = {q2, q3, q4, q5, q6};  % 创建包含所有跟随者q数据的数组

% 布局参数
nRows = 5;                         % 行数，即每个q的子图
nCols = 2;                         % 列数，即左侧大图和右侧小图
leftMargin = 0.095;                 % 左侧边距
rightMargin = 0.02;                % 右侧边距
topMargin = 0.065;                  % 顶部边距
bottomMargin = 0.065;               % 底部边距
hSpacing = 0.075;                   % 左右子图之间的间距
vSpacing = 0.04;                   % 上下子图之间的间距

% 设置左、右子图的宽度比例
leftWidthRatio = 0.60;              % 左侧子图宽度占总宽度的70%
rightWidthRatio = 1 - leftWidthRatio;  % 右侧子图占剩余30%宽度

% 计算左、右子图的实际宽度
totalWidth = 1 - leftMargin - rightMargin - hSpacing;  % 子图的总宽度
leftSubplotWidth = totalWidth * leftWidthRatio;        % 左侧子图的宽度
rightSubplotWidth = totalWidth * rightWidthRatio;      % 右侧子图的宽度

% 计算子图的高度
totalHeight = 1 - topMargin - bottomMargin - (nRows-1)*vSpacing;  % 子图的总高度
subplotHeight = totalHeight / nRows;                              % 每个子图的高度

% 在顶部预留空间放置图例
legendHeight = 0.045;        % 图例区域高度
subPlotTop = 1 - topMargin - legendHeight;  % 计算顶部位置

% 定义曲线的标签，便于在注释和图例中使用
curve_labels = {'q_{i1}', 'q_{i2}', 'q_{i3}', 'q_{i4}', 'q_{i5}', 'q_{i6}'};

% 循环绘制每个跟随者的数据，生成左右子图
for i = 1:length(q_matrix)
    bottomPos = bottomMargin + (nRows - i)*(subplotHeight + vSpacing);  % 计算每个子图的底部位置
    
    % 左侧大图
    leftPosLeft = leftMargin;  % 左侧子图的左边界位置
    axLeft = subplot('Position', [leftPosLeft, bottomPos, leftSubplotWidth, subplotHeight]);  % 创建左侧子图
    hold on;
    q_data = q_matrix{i};  % 获取当前跟随者的q数据
    box on;
    
    % 绘制曲线
    p1 = plot(tout, q_data(:, 1), 'k-', 'LineWidth', 1.5);  % q_{i1} 曲线
    p2 = plot(tout, q_data(:, 2), 'r:', 'LineWidth', 1.5);  % q_{i2} 曲线
    p3 = plot(tout, q_data(:, 3), 'b--', 'LineWidth', 1.5); % q_{i3} 曲线
    p4 = plot(tout, q_data(:, 4), 'm-.', 'LineWidth', 1.5); % q_{i4} 曲线
    p5 = plot(tout, q_data(:, 5), 'r-.', 'LineWidth', 1.5); % q_{i5} 曲线
    p6 = plot(tout, q_data(:, 6), 'k--', 'LineWidth', 1.5); % q_{i6} 曲线
    
    % 保持图形
    hold on;
    
    % 获取当前 y 轴范围
    yl = ylim;
    
    % 定义需要标记的时间区间
    rest_intervals = [15 20; 45 55; 150 170; 200 220];
    
    % 在指定的时间区间添加灰色透明区域和竖直虚线
    for j = 1:size(rest_intervals, 1)
        x1 = rest_intervals(j, 1);
        x2 = rest_intervals(j, 2);
    
        % 添加灰色透明填充区域，使用 patch 并设置透明度
        patch('XData', [x1 x2 x2 x1], 'YData', [yl(1) yl(1) yl(2) yl(2)], ...
              'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    
        % 添加竖直虚线
        plot([x1 x1], yl, 'k--', 'LineWidth', 1.0, 'HandleVisibility', 'off');
        plot([x2 x2], yl, 'k--', 'LineWidth', 1.0, 'HandleVisibility', 'off');
    
    end
    
    % 恢复原始的 y 轴范围，防止因添加元素而改变
    ylim(yl);

    % 设置图例位置和样式，仅在第一个左侧子图中显示图例
    if i == 1  
        lgd = legend([p1, p2, p3, p4, p5, p6], curve_labels);  % 显示各 q_i 的图例
        % 设置 legend 居中显示
        lgd.Position(1) = (1 - lgd.Position(3)) / 2;
        lgd.Position(2) = subPlotTop;
        set(lgd, 'Orientation', 'horizontal', 'FontSize', 10.5);
    end
    
    ylabel(['q_{', num2str(i+1), '}/m']);  % 显示当前跟随者的 ylabel，例如 q_2, q_3
    if i == length(q_matrix)
        xlabel('Time (s)');     % 仅在最后一个左侧图中显示X轴标签
    end
    set(gca, 'FontSize', 10.5);
    
    
    % 右侧小图
    leftPosRight = leftMargin + leftSubplotWidth + hSpacing;  % 右侧子图的左边界位置
    axRight = subplot('Position', [leftPosRight, bottomPos, rightSubplotWidth, subplotHeight]);  % 创建右侧子图
    hold on;
    box on;
    

    % 绘制右侧小图，显示最后25秒的数据
    t_end = max(tout);
    idx = tout > (t_end - 25);  % 最后25秒的时间索引
    plot(tout(idx), q_data(idx, 1), 'k-', 'LineWidth', 1.5);  % q_{i1}曲线
    plot(tout(idx), q_data(idx, 2), 'r:', 'LineWidth', 1.5);  % q_{i2}曲线
    plot(tout(idx), q_data(idx, 3), 'b--', 'LineWidth', 1.5); % q_{i3}曲线
    plot(tout(idx), q_data(idx, 4), 'm-.', 'LineWidth', 1.5); % q_{i4}曲线
    plot(tout(idx), q_data(idx, 5), 'r-.', 'LineWidth', 1.5); % q_{i5}曲线
    plot(tout(idx), q_data(idx, 6), 'k--', 'LineWidth', 1.5); % q_{i6}曲线
    xlim([t_end - 25, t_end]);
    if i == length(q_matrix)
        xlabel('Time (s)');     % 仅在最后一个右侧图中显示X轴标签
    end
    xlim([225,250]);
    if i==2 || i==4
        %ylim([-0.01,0.01]);
        %yticks([-0.01, 0, 0.01]);
    elseif i==3 || i==5
        %ylim([-0.02,0.02]);
        %yticks([-0.02, 0, 0.02]);
    end

    set(gca, 'FontSize', 10.5);

    % 设置坐标轴刻度标签使用 LaTeX 解释器，并替换负号
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    ax.XTickLabel = strrep(ax.XTickLabel, '-', '$-$');
    ax.YTickLabel = strrep(ax.YTickLabel, '-', '$-$');

end

% 全局字体设置
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 10.5);  % 设置图形中的字体大小
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Times New Roman');  % 设置字体类型


% 保存图形
saveas(gcf,'.\figure\q.png');  % 将图形保存为图片文件











%% 控制输入u
% 获取并索引各个控制输入
u_f = out.u(:, [8, 12, 16, 20, 24]);    % 控制输入 f
u_taux = out.u(:, [5, 9, 13, 17, 21]);  % 控制输入 taux
u_tauy = out.u(:, [6, 10, 14, 18, 22]); % 控制输入 tauy
u_tauz = out.u(:, [7, 11, 15, 19, 23]); % 控制输入 tauz

% 主图设置
figure;
set(gcf, 'unit', 'centimeters', 'position', [5 5 16 18]);  % 设置图形大小和位置
set(gca, 'LooseInset', [0, 0, 0, 0]);  % 去除边缘空白

% 创建包含所有控制输入的数据单元数组
u_matrix = {u_f, u_taux, u_tauy, u_tauz};
input_labels = {'f_t/N', '\tau_x/N·m', '\tau_y/N·m', '\tau_z/N·m'};  % 输入标签

% 布局参数
nRows = 4;                          % 子图的行数（每个控制输入一行）
nCols = 2;                          % 列数，左侧主图和右侧小图
leftMargin = 0.09;                 % 左侧边距
rightMargin = 0.02;                 % 右侧边距
topMargin = 0.070;                  % 顶部边距
bottomMargin = 0.075;               % 底部边距
hSpacing = 0.060;                   % 左右子图之间的间距
vSpacing = 0.065;                    % 上下子图之间的间距

% 设置左、右子图的宽度比例
leftWidthRatio = 0.6;               % 左侧子图占总宽度的60%
rightWidthRatio = 1 - leftWidthRatio; % 右侧子图占剩余40%宽度

% 计算左右子图的实际宽度
totalWidth = 1 - leftMargin - rightMargin - hSpacing;  % 总宽度
leftSubplotWidth = totalWidth * leftWidthRatio;        % 左侧子图宽度
rightSubplotWidth = totalWidth * rightWidthRatio;      % 右侧子图宽度

% 计算子图的高度
totalHeight = 1 - topMargin - bottomMargin - (nRows - 1) * vSpacing;  % 子图总高度
subplotHeight = totalHeight / nRows;                                  % 每个子图的高度

% 循环绘制每个控制输入的数据，生成左右子图
for i = 1:length(u_matrix)
    bottomPos = bottomMargin + (nRows - i) * (subplotHeight + vSpacing);  % 计算每个子图的底部位置
    
    % 左侧主图
    leftPosLeft = leftMargin;  % 左侧主图的左边界位置
    axLeft = subplot('Position', [leftPosLeft, bottomPos, leftSubplotWidth, subplotHeight]);  % 创建左侧子图
    hold on;
    u_data = u_matrix{i};  % 获取当前控制输入的数据
    box on;
    
    % 绘制曲线
    plot(tout, u_data(:, 1), 'k-', 'LineWidth', 1.5);  % u_{i1} 曲线
    plot(tout, u_data(:, 2), 'r:', 'LineWidth', 1.5);  % u_{i2} 曲线
    plot(tout, u_data(:, 3), 'b--', 'LineWidth', 1.5); % u_{i3} 曲线
    plot(tout, u_data(:, 4), 'm-.', 'LineWidth', 1.5); % u_{i4} 曲线
    plot(tout, u_data(:, 5), 'r-.', 'LineWidth', 1.5); % u_{i5} 曲线
    
    % 设置图例位置和样式，仅在第一个左侧子图中显示图例
    if i == 1
        lgd = legend('u_f_1', 'u_f_2', 'u_f_3', 'u_f_4', 'u_f_5');
        lgd.Position(1) = (1 - lgd.Position(3)) / 2; % 居中显示图例
        lgd.Position(2) = 1 - topMargin - 0.020;      % 设置顶部位置
        set(lgd, 'Orientation', 'horizontal', 'FontSize', 10.5);
    end
    
    ylabel(input_labels{i});  % 设置当前子图的 y 轴标签
    if i == length(u_matrix)
        xlabel('Time (s)');  % 仅在最后一个子图中显示 X 轴标签
    end
    
    % 根据控制输入类型设置 y 轴范围
    if i == 2
        ylim([-5, 5]);
    elseif i == 3
        ylim([-2, 2]);
    elseif i ==4
        ylim([-0.1,0.1]);
    end
    
    % 右侧小图，显示最后50秒的数据
    rightPosLeft = leftMargin + leftSubplotWidth + hSpacing;  % 右侧子图的左边界位置
    axRight = subplot('Position', [rightPosLeft, bottomPos, rightSubplotWidth, subplotHeight]);  % 创建右侧子图
    hold on;
    box on;

    % 绘制右侧小图的曲线
    t_end = max(tout);
    idx = tout > (t_end - 50);  % 最后50秒的时间索引
    plot(tout(idx), u_data(idx, 1), 'k-', 'LineWidth', 1.5);  % u_{i1} 曲线
    plot(tout(idx), u_data(idx, 2), 'r:', 'LineWidth', 1.5);  % u_{i2} 曲线
    plot(tout(idx), u_data(idx, 3), 'b--', 'LineWidth', 1.5); % u_{i3} 曲线
    plot(tout(idx), u_data(idx, 4), 'm-.', 'LineWidth', 1.5); % u_{i4} 曲线
    plot(tout(idx), u_data(idx, 5), 'r-.', 'LineWidth', 1.5); % u_{i5} 曲线
    xlim([t_end - 50, t_end]);
    
    % 设置右侧小图的 y 轴范围（根据控制输入调整）
    if i == 2
        ylim([-0.7, 0.7]);
    elseif i == 3
        ylim([-0.6, 0.7]);
    elseif i ==4
        %ylim([-0.1,0.1]);
    end
    if i == length(u_matrix)
        xlabel('Time (s)');  % 仅在最后一个子图中显示 X 轴标签
    end

    % 设置坐标轴刻度标签使用 LaTeX 解释器，并替换负号
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    ax.XTickLabel = strrep(ax.XTickLabel, '-', '$-$');
    ax.YTickLabel = strrep(ax.YTickLabel, '-', '$-$');
end

% 全局字体设置
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 10.5);
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Times New Roman');

% 保存图形
saveas(gcf, '.\figure\u.png');  % 将图形保存为图片文件













%% 事件触发次数
% 导入系统状态变量
q1_hat = [out.q_hat(:,1:6)];        q2_hat = [out.q_hat(:,7:12)]; 
q3_hat = [out.q_hat(:,13:18)];      q4_hat = [out.q_hat(:,19:24)];
q5_hat = [out.q_hat(:,25:30)];      q6_hat = [out.q_hat(:,31:36)];

% 记录事件触发时刻
t1=[];t2=[];t3=[];t4=[];t5=[];t6=[];
t1_interval=[]; t2_interval=[]; t3_interval=[];
t4_interval=[]; t5_interval=[]; t6_interval=[];

% 获取事件触发时刻的时间
for m=2:size(tout,1)
    if q1_hat(m,1) ~= q1_hat(m-1,1)
        t1 = [t1 tout(m)];
    end
    if q2_hat(m,1)~= q2_hat(m-1,1)
        t2 = [t2 tout(m)];
    end
    if q3_hat(m,1)~= q3_hat(m-1,1)
        t3 = [t3 tout(m)];
    end
    if q4_hat(m,1)~= q4_hat(m-1,1)
        t4 = [t4 tout(m)];
    end
    if q5_hat(m,1)~= q5_hat(m-1,1)
        t5 = [t5 tout(m)];
    end
    if q6_hat(m,1)~= q6_hat(m-1,1)
        t6 = [t6 tout(m)];
    end
end

% 判断事件触发时间间隔是否满足 < 0.06
% 如果两个时间<0.06，则舍弃
t1_temp=[];     t2_temp=[];     t3_temp=[];
t4_temp=[];     t5_temp=[];     t6_temp=[];
t_limit = 0.006;
for i=2:size(t2,2)
    if t2(i) - t2(i-1)>=t_limit
        t2_temp = [t2_temp t2(i)];
    end
end 
for i=2:size(t3,2)
    if t3(i)-t3(i-1) >= t_limit
        t3_temp = [t3_temp t3(i)];
    end
end 
for i=2:size(t4,2)
    if t4(i)-t4(i-1) >= t_limit
        t4_temp = [t4_temp t4(i)];
    end
end 
for i=2:size(t5,2)
    if t5(i)-t5(i-1) >= t_limit
        t5_temp = [t5_temp t5(i)];
    end
end 
for i=2:size(t6,2)
    if t6(i)-t6(i-1) >= t_limit
        t6_temp = [t6_temp t6(i)];
    end
end 

for i=2:size(t2_temp,2)
    t2_interval = [t2_interval t2_temp(i)-t2_temp(i-1)];
end 
t2_interval = [t2_interval 250-t2_temp(i)];
for i=2:size(t3_temp,2)
    t3_interval = [t3_interval t3_temp(i)-t3_temp(i-1)];
end
t3_interval = [t3_interval 250-t3_temp(i)];
for i=2:size(t4_temp,2)
    t4_interval = [t4_interval t4_temp(i)-t4_temp(i-1)];
end
t4_interval = [t4_interval 250-t4_temp(i)];
for i=2:size(t5_temp,2)
    t5_interval = [t5_interval t5_temp(i)-t5_temp(i-1)];
end
t5_interval = [t5_interval 250-t5_temp(i)];
for i=2:size(t6_temp,2)
    t6_interval = [t6_interval t6_temp(i)-t6_temp(i-1)];
end
t6_interval = [t6_interval 250-t6_temp(i)];


% 定义事件触发数据
t_temp = {t2_temp, t3_temp, t4_temp, t5_temp, t6_temp};  % 事件触发时间
t_interval = {t2_interval, t3_interval, t4_interval, t5_interval, t6_interval};  % 事件触发间隔
agents_labels = {'Agent2', 'Agent3', 'Agent4', 'Agent5', 'Agent6'};  % 各个代理的标签


% 主图设置
figure(4);
set(gcf, 'unit', 'centimeters', 'position', [5 5 16.5 18]);  % 调整整体图形大小以适应边缘调整
set(gca,'LooseInset',[0,0,0,0]);

% 确定子图之间的间距和边缘
subPlotSpacing = 0.050;  % 增大上下间距
subPlotMarginLeft = 0.1;  % 增加左边距
subPlotMarginRight = 0.05;  % 减小右边距
subPlotBottom = 0.07;  % 增加底部边距以适应x轴标签
subPlotHeight = (0.98 - subPlotBottom - 4*subPlotSpacing) / 5;  % 计算子图高度

% 循环绘制所有子图
for i = 1:length(t_temp)
    % 创建主子图
    subplot('Position', [subPlotMarginLeft, subPlotBottom + (5-i)*(subPlotHeight + subPlotSpacing), 1-subPlotMarginLeft-subPlotMarginRight, subPlotHeight]);
    hold on;
    box on;
    
    
    % 绘制主图
    stem(t_temp{i}, t_interval{i});
    ylabel(agents_labels{i});  % 设置y轴标签
    
    if i == length(t_temp)
        xlabel('Time (s)');     % 仅在最后一个图中显示X轴标签
    end

    xlim([240, 250]);
    
    % 设置全局字体
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10.5);
end

% 全局字体设置
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 10.5);
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Times New Roman');
saveas(gcf,'.\figure\event_triggers.png');

save("./figure_comparison/ETC.mat")






