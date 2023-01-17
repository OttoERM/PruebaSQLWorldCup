--Creacion de tablas
Create table Teams(
    Team_Id int not null,
    Team_name varchar(30) not null,
    Primary key (Team_Id)
);

Create table Matches(
    Match_Id int not null,
    Host_Team int not null,
    Guest_Team int not null,
    Host_Goals int not null,
    Guest_Goals int not null,
    Primary key (Match_Id)
);

--Insercion de datos
Insert into teams values
(10,'Give'),
(20,'Never'),
(30,'You'),
(40,'UP'),
(50,'Gonna');

Insert into Matches values
(1,30,20,1,0),
(2,10,20,1,2),
(3,20,50,2,2),
(4,10,30,1,0),
(5,30,50,0,1);

--Consulta
WITH dbPuntosTotales AS 
    (
    SELECT C.team_id,SUM(C.Points) AS PuntosTotales
    FROM [dbo].[Matches] AS A
    CROSS APPLY (
        SELECT host_points = CASE 
                                WHEN A.host_goals > A.guest_goals THEN 3
                                WHEN A.host_goals = A.guest_goals THEN 1
                            END
            ,guest_points = CASE 
                                WHEN A.guest_goals > A.host_goals THEN 3
                                WHEN A.host_goals = A.guest_goals THEN 1
                            END
    ) AS B
    CROSS APPLY (
        VALUES 
         (host_team,host_points)
        ,(guest_team,guest_points)
    ) AS C(team_id,points)
    GROUP BY c.team_id
)

SELECT A.Team_Id
    ,A.Team_name
    ,TotalPoints = ISNULL(PuntosTotales,0)
FROM [dbo].[Teams] AS A
LEFT JOIN dbPuntosTotales AS B
    ON A.team_Id = B.team_id order by TotalPoints Desc