Ts = logspace(-0.3,1.7, 21);

nreps = 20;
ntypes = 6;
%load data file
fid = py.open('melt_yields_T.pkl','rb');
data = py.pickle.load(fid);
T = double(data.T);

figure(2)
clf
hold on
ntet = T(5,:,:);
npen = T(6,:,:);
nmon = T(2,:,:);
ndim = T(3,:,:);
ntri = T(4,:,:);
nby = ndim+ntri;
RGB = orderedcolors("gem");

s23 = shadedErrorBar(Ts,mean(nby,3),std(nby,0,3),...
    'lineprops',{'.','markersize',16,'linewidth',1,...
    'color', RGB(3,:)});
s23.patch.FaceAlpha = 0.1;


s5 = shadedErrorBar(Ts,mean(npen,3),std(npen,0,3),...
    'lineprops',{'.','markersize',16,'linewidth',1,...
    'color', RGB(5,:)});
s5.patch.FaceAlpha = 0.1;

% s1 = shadedErrorBar(Ts,mean(nmon,3),std(nmon,0,3),...
%     'lineprops',{'.','markersize',14,'linewidth',1,...
%     'color', RGB(2,:)});
% s1.patch.FaceAlpha = 0.1;

s4 = shadedErrorBar(Ts,mean(ntet,3),std(ntet,0,3),...
    'lineprops',{'.','markersize',16,'linewidth',1,...
    'color',RGB(1,:)});
set(s4.edge,'LineWidth',2,'LineStyle','-')
% s4.mainLine.LineWidth = 5;
s4.patch.FaceAlpha = 0.3;

set(gca,'xscale','log')
set(gca,'fontsize',16)
xlabel('T_{melt}')
ylabel('n_{remain}/n_0')
axis([Ts(1)*0.5 Ts(end) 0 1.3])
box on
% fName = 'fig_virtualize';
% set(gcf, 'Renderer', 'painters');
% fig.PaperPositionMode = 'manual';
% fig.PaperUnits = 'centimeters';
% fig.PaperPosition = [0 0 fSize];
% fig.PaperSize = fSize;
% saveas(fig, fName, 'pdf');
% set(gcf, 'Renderer', 'opengl');