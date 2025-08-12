nreps = 20;
nsteps = 2.5E5;
%load data file
fid = py.open('yields_cycle_reps.pkl','rb');
fid2 = py.open('yields_sim_reps.pkl','rb');
data = py.pickle.load(fid);
data2 = py.pickle.load(fid2);
T = double(data.T);
T2 = double(data2.T);

figure(1)
clf
hold on
ntet = T(5,:,:);
ntet0 = T2(5,:,:);
RGB = orderedcolors("gem");


mntet0 = mean(ntet0,3);
sdtet0 = std(ntet0,0,3);
s40 = shadedErrorBar((1:100:242000)/(22000),mntet0(1:100:242000),sdtet0(1:100:242000),...
    'lineprops',{'-','markersize',16,'linewidth',2,...
    'color',RGB(6,:)});
set(s40.edge,'LineWidth',2,'LineStyle','-')
s40.mainLine.LineWidth = 3;
s40.patch.FaceAlpha = 0.1;

mntet = mean(ntet,3);
sdtet = std(ntet,0,3);
s4 = shadedErrorBar((1:100:242000)/(22000),mntet(1:100:242000),sdtet(1:100:242000),...
    'lineprops',{'-','markersize',16,'linewidth',2,...
    'color',RGB(1,:)});
set(s4.edge,'LineWidth',2,'LineStyle','-')
s4.mainLine.LineWidth = 3;
s4.patch.FaceAlpha = 0.3;


set(gca,'xscale','lin')
set(gca,'fontsize',16)
xlabel('number of cycles')
ylabel('yield')
axis([0 11 0 0.72])
box on