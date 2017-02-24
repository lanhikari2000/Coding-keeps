//This code will use Dijkstra to solve a simple graph with adj list

const	fi	= 'Dijkstra.inp';
	fo	= 'Dijkstra.out';
	maxn	= round(1e5)+5;
	
var	n,m	: longint;
	front,back,d	: array [0..maxn] of longint;
	adj,head,w	: array [0..maxn*2] of longint;
	l 	: array [0..maxn] of int64;
	cl,q,pos	: array [0..maxn] of longint;
	qn	: longint;
	sta,fin	: longint;
	res	: int64;
	
procedure	enter;
var	i 	: longint;
begin
	assign(input,fi); reset(input);
	readln(n,m);
	for i:=1 to m do readln(front[i],back[i],d[i]);
	readln(sta,fin);
end;

//Building forward star

procedure	buildFS;
var	i 	: longint;
	u,v	: longint;
begin
	for i:=1 to n do head[i]:=0;
	
	for i:=1 to m do
	begin
		inc(head[front[i]]);
		inc(head[back[i]]);
	end;	
	
	v:=1;
	for i:=1 to n do 
	begin
		u:=head[i];
		head[i]:=v;
		inc(v,u);
	end;	
	head[n+1]:=v;
	
	for i:=1 to m do
	begin
		u:=front[i]; v:=back[i];
		adj[head[u]]:=v; w[head[u]]:=d[i];
		adj[head[v]]:=u; w[head[v]]:=d[i];
		inc(head[u]); inc(head[v]);
	end;	
	
	for i:=n downto 2 do head[i]:=head[i-1];
	head[1]:=1;
end;	

//Using heap to speed up Dijkstra algorithm

procedure	upHeap(k	: longint);
var	v	: longint;
begin
	v:=q[k];
	while (l[v]<l[q[k]]) do
	begin
		q[k]:=q[k SHR 1];
		pos[q[k]]:=k;
		k:=k SHR 1;
	end;	
	q[k]:=v;
	pos[q[k]]:=k;
end;	

procedure	downHeap(k	: longint);
var	v,t	: longint;
begin
	v:=q[k];
	while k*2<=qn do
	begin
		t:=k*2;
		if (t<qn) and (l[q[t]]>l[q[t+1]]) then inc(t);
		if (l[v]<=l[q[t]]) then break;
		q[k]:=q[t];
		pos[q[k]]:=k;
		k:=t;
	end;	
	q[k]:=v;
	pos[q[k]]:=k;
end;	

procedure	push(k	: longint);
begin
	inc(qn);
	q[qn]:=k; pos[q[qn]]:=qn;
	upHeap(qn);
end;	

function	pop: longint;
begin
	pop:=q[1];
	q[1]:=q[qn]; pos[q[1]]:=1;
	dec(qn);
	downHeap(1);
end;	

//Main Dijkstra code

procedure	Dijkstra;
var	i 	: longint;
	u,v 	: longint;
begin
	for i:=1 to n do 
	begin
		l[i]:=0; cl[i]:=0;
	end;	
	cl[sta]:=1;
	push(sta);
	
	while (qn>0) do 
	begin
		u:=pop;
		for i:=head[u] to head[u+1]-1 do
		begin
			v:=adj[i];
			if (cl[v]=0) then
			begin
				l[v]:=l[u]+w[i];
				cl[v]:=1;
				push(v);
			end
			else if (l[v]>l[u]+w[i]) then
			begin
				l[v]:=l[u]+w[i];
				upHeap(pos[v]);
			end;	
		end;
	end;	
end;	

procedure	printResult;
begin
	assign(output,fo); rewrite(output);
	write(res);
end;	

procedure	main;
begin
	enter;
	
	buildFS;
	Dijkstra;
	
	if (cl[fin]=1) then res:=l[fin]
	else res:=-1;
	
	printResult;
end;	

BEGIN
	main;
END.	