Area_Calculator <- function (xmin, xmax, ymin, ymax, numbers,slide,proportion_threshold=0.25) {
  #xmin: the minimal boundary of the data slide, use min(slide$x).
  #xmax: the minimal boundary of the data slide, use max(slide$x).
  #ymin: the minimal boundary of the data slide, use min(slide$y).
  #ymax: the minimal boundary of the data slide, use max(slide$y).
  #numbers: the (numbers)^2 of fragments to generate.
  #slide: the segmentation.csv.gz output from Baysor, with one more column called 'Celltype'. The necessary columns for this data frames are:
  ##x
  ##y
  ##cell
  ##Celltype
  ##area
  #proportion_threshold: the percentage of area needs to be in the fragment for one cell to be assigned to it. Default is 0.25.
  xdelta=(xmax-xmin)/numbers
  ydelta=(ymax-ymin)/numbers
  slide=slide[slide$x>=xmin&slide$x<=xmax&slide$y>=ymin&slide$y<=ymax,]
  total.area=data.frame(cell=slide$cell,
                        Area=slide$area,
                        x=slide$x,
                        y=slide$y)
  area=aggregate(Area~cell,data = total.area,FUN = base::sum)
  
  
  
  
  
  xstart=xmin
  results=data.frame(xy='')
  for (i in unique(slide$Celltype)) {
    results=cbind(results,data.frame(cellnum=0))
    colnames(results)[ncol(results)]=i
  }
  while (xstart<xmax) {
    xrange=c(xstart,xstart+xdelta)
    ystart=ymin
    while(ystart < ymax) {
      yrange=c(ystart,ystart+ydelta)
      portion=slide[slide$x>=xrange[1]&slide$x<=xrange[2]&slide$y>=yrange[1]&slide$y<=yrange[2],]

      
      
      if (nrow(portion)!=0) {
        portion.total.area=data.frame(cell=portion$cell,
                                      Area=portion$area,
                                      x=portion$x,
                                      y=portion$y)
        portion.area=aggregate(Area~cell,data = portion.total.area,FUN = base::sum)
        
        
        
        temp=data.frame(xy=paste(c(xrange,yrange),collapse = ','))
        for (i in unique(slide$Celltype)) {
          temp=cbind(temp,data.frame(cellnum=0))
          colnames(temp)[ncol(temp)]=i
        }
        for (i in unique(portion$Celltype)) {
          cells=portion[portion$Celltype==i,]
          prop.stats=portion.area[portion.area$cell%in%cells$cell,]
          table=merge(prop.stats,area[area$cell%in%prop.stats$cell,],by='cell')
          table$Freq=(table$Area.x/table$Area.y)
          sum=length(table$Freq[table$Freq>proportion_threshold])
          temp[1,i]=sum
        }
        
        results=rbind(results,temp)
      }
      ystart=ystart+ydelta
    }
    xstart=xstart+xdelta
    
  }
  results=results[-1,]
  rownames(results)=results[,1]
  results=results[,-1]
  results=results[rowSums(results)>0,]
  return(results)
}

Area_Counter <- function (xmin, xmax, ymin, ymax, numbers,cell_coordinates) {
  #xmin: the minimal boundary of the data slide, use min(slide$x).
  #xmax: the minimal boundary of the data slide, use max(slide$x).
  #ymin: the minimal boundary of the data slide, use min(slide$y).
  #ymax: the minimal boundary of the data slide, use max(slide$y).
  #numbers: the (numbers)^2 of fragments to generate.
  #cell_coordinates: a data frame with the following columns:
  ##x
  ##y
  ##cell
  ##Celltype
  
  
  
  xdelta=(xmax-xmin)/numbers
  ydelta=(ymax-ymin)/numbers
  cell_coordinates=cell_coordinates[cell_coordinates$x>=(xmin)&cell_coordinates$x<=xmax&cell_coordinates$y>=ymin&cell_coordinates$y<=ymax,]

  
  
  
  
  
  xstart=xmin
  results=data.frame(xy='')
  for (i in unique(cell_coordinates$Celltype)) {
    results=cbind(results,data.frame(cellnum=0))
    colnames(results)[ncol(results)]=i
  }
  while (xstart<xmax) {
    xrange=c(xstart,xstart+xdelta)
    ystart=ymin
    while(ystart < ymax) {
      yrange=c(ystart,ystart+ydelta)
      portion=cell_coordinates[cell_coordinates$x>=xrange[1]&cell_coordinates$x<=xrange[2]&cell_coordinates$y>=yrange[1]&cell_coordinates$y<=yrange[2],]
      if (nrow(portion)!=0) {
        temp=data.frame(xy=paste(c(xrange,yrange),collapse = ','))
        for (i in unique(cell_coordinates$Celltype)) {
          temp=cbind(temp,data.frame(cellnum=0))
          colnames(temp)[ncol(temp)]=i
        }
        for (i in unique(portion$Celltype)) {
          cells=portion[portion$Celltype==i,]
          sum=as.numeric(nrow(cells))
          temp[1,i]=sum
        }
        
        results=rbind(results,temp)
      }
      ystart=ystart+ydelta
    }
    xstart=xstart+xdelta
    
  }
  results=results[-1,]
  rownames(results)=results[,1]
  results=results[,-1]
  results=results[rowSums(results)>1,]
  return(results)
}
Area_Cluster <- function(Area_table,
                         ScaleFactor=1e6,
                         Similarity_Threshold=0.5) {
  require(igraph)
  require(psych)
  require(tidyr)
  require(ggplot2)
  require(reshape2)
  
  rawtable=Area_table
  Area_table=Area_table/rowSums(Area_table)
  Area_table=Area_table*(ScaleFactor)
  Area_table=log(Area_table+1)
  correlationmatrix = cor(t(as.matrix(Area_table)))
  distancematrix <- cor2dist(correlationmatrix)
  distancematrix <- as.matrix(distancematrix)
  distancematrix[abs(correlationmatrix) < Similarity_Threshold] = 0
  Graph <- graph.adjacency(distancematrix, mode = "undirected", weighted = TRUE, diag = TRUE)
  clusterlouvain <- cluster_louvain(Graph)
  Clustering.results=data.frame(cluster=clusterlouvain$membership,row.names = clusterlouvain$names)
  Area.Cluster.assignment=merge(Clustering.results,rawtable,by=0)
  rownames(Area.Cluster.assignment)=Area.Cluster.assignment[,1]
  Area.Cluster.assignment=Area.Cluster.assignment[,-1]
  Clustering.Distribution=data.frame(cluster=as.factor(Area.Cluster.assignment$cluster),area=rownames(Area.Cluster.assignment))
  Clustering.Distribution=separate(Clustering.Distribution,col=area,into=c('xmin','xmax','ymin','ymax'),sep = ',')
  Clustering.Distribution$xmin=as.numeric(Clustering.Distribution$xmin)
  Clustering.Distribution$xmax=as.numeric(Clustering.Distribution$xmax)
  Clustering.Distribution$ymin=as.numeric(Clustering.Distribution$ymin)
  Clustering.Distribution$ymax=as.numeric(Clustering.Distribution$ymax)
  xmin=min(c(Clustering.Distribution$xmin,Clustering.Distribution$xmax))
  xmax=max(c(Clustering.Distribution$xmin,Clustering.Distribution$xmax))
  interage=xmax-xmin
  xmin=xmin-0.25*interage
  xmax=xmax+0.25*interage
  ymin=min(c(Clustering.Distribution$ymin,Clustering.Distribution$ymax))
  ymax=max(c(Clustering.Distribution$ymin,Clustering.Distribution$ymax))
  interage=ymax-ymin
  ymin=ymin-0.25*interage
  ymax=ymax+0.25*interage
  Clustering.Distribution.plot=ggplot()+xlim(xmin,xmax)+
    ylim(ymin,ymax)+
    geom_rect(data=Clustering.Distribution,aes(xmin=xmin,xmax=xmax,
                                               ymin=ymin,ymax=ymax,
                                               fill=cluster),alpha=0.5)+
    geom_text(data=Clustering.Distribution, aes(x=xmin+(xmax-xmin)/2, y=ymin+(ymax-ymin)/2, label=cluster), size=2)+ theme_bw() +xlab('x') +ylab('y') + 
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
    )
  melt=Area.Cluster.assignment
  melt$cluster=as.factor(melt$cluster)
  melt=melt(melt,id.vars='cluster')
  colnames(melt)=c('Cluster','CellType','Cells')
  Cluster_cell_composition=ggplot(melt,aes(x=Cells,y=Cluster,fill=CellType))+geom_bar(stat = 'identity',position = 'fill')+ theme_bw()
  return(list(Area.Cluster.assignment=Area.Cluster.assignment,
              Clustering.Distribution=Clustering.Distribution,
              Clustering.Distribution.plot=Clustering.Distribution.plot,
              Cluster_cell_composition=Cluster_cell_composition))
  
}

