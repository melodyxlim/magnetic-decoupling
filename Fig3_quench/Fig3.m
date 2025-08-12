%%code to produce Fig 3 of "Magnetic Decoupling as a Proof-Reading Strategy
%%for high-yield, time-efficient self-assemly"

%Fig 3f

%run on dataset yields_12Oe10Hz

figure(1)
clf
box on
hold on
tlist = 0:length(npanels)-1;
tlist = tlist-54; %center timeseries on time when magnetic field drops
tlist = (tlist)/fps;
tiledlayout(2,1,'TileSpacing','none')
nexttile
plot(tlist,Bmag,'LineWidth',2,'color',[0.6350    0.0780    0.1840])
axis([-60 2500 0 45])
set(gca,'FontSize',16)
ylabel('B [G]')
nexttile
hold on

plot(tlist, nmonomers./npanels,...
    'Color',[0.8500    0.3250    0.0980],'linewidth',2)
plot(tlist,(npanels-ntetramers-nmonomers)./npanels,...
    'color',[0.9290    0.6940    0.1250],'linewidth',2)
plot(tlist, ntetramers./npanels,...
    'color',[0 0.4470 0.7410],'linewidth',2)

xlabel('time [s]')
ylabel('yield')

set(gca,'FontSize',16)
axis([-60  2500 0 1.1])

%%
%Fig 3g: run on quench data
flist =  ls('*.mat');
% flist = flist([1:12],:);
tlist={};
maglist=[];
ylist=[];
% maglist = zeros(size(flist,1),2);
pfluc = 0.1;
for k = 1:size(flist,1)
    magpar = sscanf(flist(k,:),'%fOe%fHz');
    if magpar(2) <30
        magpar = magpar(:)';
        maglist = [maglist;magpar];
        load(flist(k,:),'npanels','ntetramers','nmonomers')
%                 load(flist(k,:),'npanels','ntetramers')
        %automated detection of final probability (variance below set
        %threshold)
        ymon = nmonomers./npanels;
        ytet = ntetramers./npanels;
        ytet = ytet(~isnan(ytet));
        dataIntvar = nanstd(ytet)/nanmean(ytet);
        yseg = ytet;
        ymon = ymon(~isnan(ymon));
        ysegm = ymon;
        mid = ceil(length(npanels)/2);
        while (dataIntvar>=pfluc) && (mid<length(yseg)-1)
            top = yseg(1:mid);
            bot = yseg(mid+1:end);
            vartop = nanstd(top)/nanmean(top);
            varbot = nanstd(bot)/nanmean(bot);
            varbot(isnan(varbot))=0;
            vartop(isnan(vartop))=0;
            if vartop < varbot
                dataIntvar = vartop;
                mid = mid - ceil(mid/2);
                yseg = top;
                ysegm = ymon(1:mid);

            elseif varbot <=vartop
                dataIntvar = varbot;
                mid = mid + ceil(mid/2);
                yseg = bot;
                ysegm = ymon(mid+1:end);
            end
        end
        ylist=[ylist;[nanmean(yseg),nanstd(yseg),nanmean(ysegm),nanstd(ysegm)]];
%                 ylist=[ylist;[nanmean(yseg),nanstd(yseg)]];
    end
end

figure(1)
clf
hold on
[C,ia,idx] = unique(maglist(:,1),'stable');
valt = accumarray(idx,ylist(:,3),[],@mean); 
valt2 = accumarray(idx,ylist(:,3),[],@std);
[B,It]=sort(C);
smon = shadedErrorBar(C(It),valt(It),valt2(It),'lineprops',...
    {'.','markersize',20,'color',[0.8500 0.3250 0.0980]},'patchSaturation',0.05)
[C,ia,idx] = unique(maglist(:,1),'stable');
val = accumarray(idx,ylist(:,1),[],@mean); 
val2 = accumarray(idx,ylist(:,1),[],@std);
[B,I]=sort(C);
sby = shadedErrorBar(C(I),1-valt(It)-val(I),valt2(I),'lineprops',...
    {'.','markersize',20,'color',[0.9290    0.6940    0.1250]},'patchSaturation',0.05)
stet = shadedErrorBar(C(I),val(I),val2(I),'lineprops',...
    {'.','markersize',20,'color',[0 0.4470 0.7410]},'patchSaturation',0.3)

set(stet.edge,'LineWidth',2)
set(sby.edge,'LineWidth',0.5)
set(smon.edge,'LineWidth',0.5)

set(gca,'xscale','lin')
set(gca,'yscale','lin')
axis([0 40 0 1.0])
box on
set(gca,'fontsize',14)
ylabel('yield')
xlabel('B_{quench} [Oe]')
findfigs