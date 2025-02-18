clc
clear
close all


% 事件触发控制
load ETC.mat
n_ETC = [size(t1_interval,2) size(t2_interval,2) size(t3_interval,2) size(t4_interval,2) size(t5_interval,2) size(t6_interval,2)];
load ETC_comparison1.mat
n_ETIC = [size(t1_interval,2) size(t2_interval,2) size(t3_interval,2) size(t4_interval,2) size(t5_interval,2) size(t6_interval,2)];

% 绘制对比柱状图
n_comparison = [];
for i = 2:6
    n_comparison = [n_comparison;n_ETC(i)  n_ETIC(i)];
end


figure
% set(gcf,'unit','centimeters','position',[5 5 10.5 7.5])
set(gcf,'unit','centimeters','position',[5 5 14.5 6.0])
set(gca,'LooseInset',[0,0,0.02,0]);
% X = categorical({'Agent2','Agent3','Agent4','Agent5','Agent6'});
% X = reordercats(X,{'Agent2','Agent3','Agent4','Agent5','Agent6'});
bar(n_comparison);
set(gca,'XTickLabel',{'Agent2','Agent3','Agent4','Agent5','Agent6'},'Fontsize',12,'FontName','Times New Roman')
legend('data A','data B','data C','Fontsize',15,'FontName','Times New Roman');
lgd = legend('Non-intermittent ETC','Proposed ETC','location','Northwest','FontSize',12);
% set(lgd,'Orientation','horizon')
set(lgd,'FontName','Times New Roman');
ylabel('The number of triggers');
set(get(gca,'XLabel'),'FontSize',12,'FontName','Times New Roman');
set(get(gca,'YLabel'),'FontSize',12,'FontName','Times New Roman');
ylim([0,700])


saveas(gcf, '.\comparison.png');