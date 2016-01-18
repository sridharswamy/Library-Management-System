-- PROCEDURE TO CHECK OUT A RESOURCE (PART 1)

CREATE OR REPLACE PROCEDURE CA(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE
)
AS avail varchar(20);
hold_position int;
priority int;

BEGIN
hold_position:=0;
Select availability into avail from lib_resource where resource_id=p_resource_id;

Select PRIORITY into priority from member where MEMBER_ID=p_member_id;

if(priority=3) THEN
DBMS_OUTPUT.PUT_LINE('YOU ARE IN SUSPEND LIST');
else
        if avail='Available' THEN
                        CA1(p_resource_id,p_member_id);
        else
                        if(SUBSTR(p_member_id,1,1)='F') THEN
                                Select Count(*) into hold_position from HOLD_QUEUE where resource_id=p_resource_id;
                                INSERT into HOLD_QUEUE values(p_resource_id,p_member_id,2,hold_position+1);
                                COMMIT;
                        else
                                Select Count(*) into hold_position from HOLD_QUEUE where resource_id=p_resource_id;
                                INSERT into HOLD_QUEUE values(p_resource_id,p_member_id,1,hold_position+1);
                                COMMIT;
                        end if;
                        COMMIT;
                        Select Count(*) into hold_position from HOLD_QUEUE where resource_id=p_resource_id;
                        DBMS_OUTPUT.PUT_LINE('Book is presently unavailable. You have been placed in the hold queue at position '||hold_position);

        END IF;
END IF;
END CA;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/


-- PROCEDURE TO CHECK OUT A RESOURCE (CALLED BY PART 1)

CREATE OR REPLACE PROCEDURE CA1(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE
)

AS r_id varchar(20);
res varchar(20);
course_count int;
eligibility boolean;
p_publish_format varchar(20);
already_issued integer;

Titleval varchar(100);
SRT TIMESTAMP;

BEGIN
COMMIT;
eligibility:=false;

Select RESOURCE_ID into r_id from lib_resource where resource_id=p_resource_id;

select count(*) into course_count from student_takes_course
where member_id=p_member_id and course_id in (
		select c.course_id
        from book b,course c
        where b.ISBN=c.ISBN and b.ISBN in (
                select r.resource_id
                from  lib_resource r, book b
                where r.resource_id=b.resource_id and
                b.resource_id=p_resource_id)
        );
select count(*) into already_issued from book b
where resource_id=p_resource_id and ISBN in (
select ISBN from Book B
        where resource_id in
   (select resource_id from member_issues_resource
        where member_id=p_member_id)
);
        if(course_count=1) then
                eligibility:=true;
       else
                eligibility:=false;
       end if;


if (already_issued=0) then
        if (SUBSTR(r_id,1,1)='B') THEN
                Select B.Reserved into res from Book B,Lib_Resource LR where B.RESOURCE_ID=LR.RESOURCE_ID and B.RESOURCE_ID=p_resource_id;

                select publish_format into p_publish_format
                from publication p,book b

                where p.resource_id=b.resource_id
                and p.resource_id=p_resource_id;

                if(res='Yes') THEN
                                if(eligibility) THEN
                                        INSERT into Member_issues_resource values(p_member_id,p_resource_id,sysdate,2,sysdate+(4/24));

                                        UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;

                                        COMMIT;
                                        Select title into titleval from Publication P where P.resource_id=p_resource_id;

                                        Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;

                                        DBMS_OUTPUT.PUT_LINE('You have successfully checked out the reserved copy!');

                                        Insert into notification values(p_member_id,sysdate,'You have successfully issued the reserved book '||titleval||' and it will be due on'||' '||SRT);
										Update lib_resource set availabilitydate=sysdate+(4/24) where resource_id=p_resource_id;

                                        COMMIT;
                                else
                                        DBMS_OUTPUT.PUT_LINE('You cannot issue the reserved book');
                        end if;
        else
                if(p_publish_format='Physical Copy') THEN
                        if(SUBSTR(p_member_id,1,1)='F') THEN

                                INSERT into Member_issues_resource values(p_member_id,p_resource_id,sysdate,2,sysdate+30);

                                UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;
								COMMIT;
                                
								Update lib_resource set availabilitydate=sysdate+30 where resource_id=p_resource_id;
                                COMMIT;
                                Select title into titleval from Publication P where P.resource_id=p_resource_id;

                                Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;


                                DBMS_OUTPUT.PUT_LINE('You have successfully issued the book '||titleval);
                                DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);
                                Insert into notification values(p_member_id,sysdate,'You have successfully issued the book '||titleval||' and it will be due on'||' '||SRT);

                                COMMIT;
                        else
                                        INSERT into Member_issues_resource values(p_member_id,p_resource_id,sysdate,2,sysdate+14);


                                        UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;
										Update lib_resource set availabilitydate=sysdate+14 where resource_id=p_resource_id;
                                
                                        COMMIT;
                                        Select title into titleval from Publication P where P.resource_id=p_resource_id;

                                        Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;

                                        DBMS_OUTPUT.PUT_LINE('You have successfully issued the book '||titleval);

                                        DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);
                                        Insert into notification values(p_member_id,sysdate,'You have successfully issued the book '||titleval||' and it will be due on'||' '||SRT);

                                        COMMIT;
                                end if;
                else
                        DBMS_OUTPUT.PUT_LINE('You have successfully checked out the electronic copy');

                end if;


        end if;
end if;
else
        DBMS_OUTPUT.PUT_LINE('Sorry You already have this book issued');
end if;

if SUBSTR(r_id,1,1)='J' THEN
        INSERT into Member_issues_resource values(p_member_id,p_resource_id,sysdate,2,sysdate+(12/24));

        UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;
		Update lib_resource set availabilitydate=sysdate+(12/24) where resource_id=p_resource_id;
                                
        COMMIT;
        Select title into titleval from Publication P where P.resource_id=p_resource_id;

        Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;

        DBMS_OUTPUT.PUT_LINE('You have successfully issued the journal '||titleval);
        DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);


        Insert into notification values(p_member_id,sysdate,'You have successfully issued the journal '||titleval||' and it will be due on'||' '||SRT);

        COMMIT;
end if;

if SUBSTR(r_id,1,2)='CP' THEN
        INSERT into Member_issues_resource values(p_member_id,p_resource_id,sysdate,2,sysdate+(12/24));

        UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;
		Update lib_resource set availabilitydate=sysdate+(12/24) where resource_id=p_resource_id;
        
        COMMIT;
        Select title into titleval from Publication P where P.resource_id=p_resource_id;

        Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;

        DBMS_OUTPUT.PUT_LINE('You have successfully issued the conference paper '||titleval);


        DBMS_OUTPUT.PUT_LINE('which is due on '||SRT);
        Insert into notification values(p_member_id,sysdate,'You have successfully issued the conference paper '||titleval||' and it will be due on'||' '||SRT);

        COMMIT;
end if;
COMMIT;
END CA1;


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- PROCEDURE TO RENEW A RESOURCE

CREATE OR REPLACE PROCEDURE RENEW(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE
)
AS
date_diff int;
priority int;
count1 int;
Titleval varchar(100);
SRT TIMESTAMP;
res varchar(20);

p_publish_format varchar(20);

BEGIN

Select Count(*) into count1 from HOLD_QUEUE where RESOURCE_ID=p_resource_id;
Select PRIORITY into priority from member where MEMBER_ID=p_member_id;

if(priority=0) THEN
        DBMS_OUTPUT.PUT_LINE('YOU ARE IN SUSPEND LIST!');
else
        if(count1>0) THEN

        DBMS_OUTPUT.PUT_LINE('YOU CANNOT RENEW THE BOOK. IT HAS BEEN PLACED ON HOLD!');


        else
                if (SUBSTR(p_resource_id,1,1)='B') THEN
                        Select B.Reserved into res from Book B,Lib_Resource LR where B.RESOURCE_ID=LR
.RESOURCE_ID and B.RESOURCE_ID=p_resource_id;

                        select publish_format into p_publish_format from publication p,book b where p.resource_id=b.resource_id and p.resource_id=p_resource_id;
                        if(res='Yes') THEN
			Update Member_issues_resource M set ISSUE_TIME=sysdate, SCHEDULED_RETURN_TIME=sysdate+(4/24) where M.member_id=p_member_id and M.resource_id=p_resource_id;
       COMMIT;
       Select title into titleval from Publication P where P.resource_id=p_resource_id;
       Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;
       DBMS_OUTPUT.PUT_LINE('You have successfully renewed the reserved copy!');
       Insert into notification values(p_member_id,sysdate,'You have successfully renewed the reserved book "'||titleval||'" and it will be due on'||' '||SRT);
       COMMIT;
                        else
       if(SUBSTR(p_member_id,1,1)='F') THEN
               Update Member_issues_resource M set ISSUE_TIME=sysdate, SCHEDULED_RETURN_TIME=sysdate+30 where M.member_id=p_member_id and M.resource_id=p_resource_id;
               COMMIT;
               Select title into titleval from Publication P where P.resource_id=p_resource_id;
               Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;
               DBMS_OUTPUT.PUT_LINE('FACULTY, You have successfully renewed the book '||titleval);
               DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);
               Insert into notification values(p_member_id,sysdate,'You have successfully renewed the book "'||titleval||'" and it will be due on'||' '||SRT);
               COMMIT;
       else
               Update Member_issues_resource M set ISSUE_TIME=sysdate, SCHEDULED_RETURN_TIME=sysdate+14 where M.member_id=p_member_id and M.resource_id=p_resource_id;
               COMMIT;
               Select title into titleval from Publication P where P.resource_id=p_resource_id;
               Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;
               DBMS_OUTPUT.PUT_LINE('STUDENT, You have successfully renewed the book '||titleval);
               DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);
               Insert into notification values(p_member_id,sysdate,'You have successfullyrenewed the book "'||titleval||'" and it will be due on'||' '||SRT);
               COMMIT;
       end if;
                        end if;
                end if;

                if SUBSTR(p_resource_id,1,1)='J' THEN
                        Update Member_issues_resource M set ISSUE_TIME=sysdate, SCHEDULED_RETURN_TIME=sysdate+(12/24) where M.member_id=p_member_id and M.resource_id=p_resource_id;
                        COMMIT;
                        Select title into titleval from Publication P where P.resource_id=p_resource_id;
                        Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;
                        DBMS_OUTPUT.PUT_LINE('You have successfully renewed the journal '||titleval);
                        DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);
                        Insert into notification values(p_member_id,sysdate,'You have successfully renewed the journal "'||titleval||'" and it will be due on'||' '||SRT);
                        COMMIT;
                end if;

                if SUBSTR(p_resource_id,1,2)='CP' THEN
                        Update Member_issues_resource M set ISSUE_TIME=sysdate, SCHEDULED_RETURN_TIME=sysdate+(12/24) where M.member_id=p_member_id and M.resource_id=p_resource_id;
                        COMMIT;
                        Select title into titleval from Publication P where P.resource_id=p_resource_id;
                        Select Scheduled_Return_Time into SRT from Member_Issues_Resource M where M.member_id=p_member_id and M.resource_id=p_resource_id;
                        DBMS_OUTPUT.PUT_LINE('You have successfully renewed the conference paper '||titleval);
                        DBMS_OUTPUT.PUT_LINE('which is due on'||SRT);
                        Insert into notification values(p_member_id,sysdate,'You have successfully renewed the conference paper "'||titleval||'" and it will be due on'||' '||SRT);
                        COMMIT;

                end if;
        COMMIT;
END IF;
END IF;
END RENEW;



/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--SENDS NOTIFICATION TO THE FIRST PERSON ON THE HOLD QUEUE WHEN A RESOURCE IS RETURNED


CREATE OR REPLACE PROCEDURE Allocate_Resource(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE
)

AS book_title varchar(100);
num_of_holds int;
hold_member_id varchar(30);
BEGIN
num_of_holds:=0;

Update lib_resource set availability='Available' where resource_id=p_resource_id;
COMMIT;

Delete from member_issues_resource where resource_id=p_resource_id and member_id=p_member_id;
COMMIT;

Select count(*) into num_of_holds from hold_queue where resource_id=p_resource_id;
if(num_of_holds>0) then
	SELECT member_id into hold_member_id FROM ( Select * from hold_queue WHERE resource_id= p_resource_id  order by priority desc,hold_position asc) where rownum=1;
	Select Title into book_title from publication where RESOURCE_ID=p_resource_id;
	Insert into Notification values (hold_member_id,sysdate,'Availability of Requested Book :'||book_title||'. You can now Check it out');
	COMMIT;
end if;


COMMIT;

END Allocate_Resource;
/

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- PROCEDURE TO RETURN A RESOURCE

CREATE OR REPLACE PROCEDURE RETURNING(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE
)

AS r_id varchar(20);
res varchar(20);
return_time timestamp;
days integer;
hours integer;

BEGIN

Select RESOURCE_ID into r_id from lib_resource where resource_id=p_resource_id;
Select SCHEDULED_RETURN_TIME into return_time from MEMBER_ISSUES_RESOURCE where resource_id=p_resource_id and member_id=p_member_id;

Select extract(day from (SYSTIMESTAMP-return_time)) into days from dual;
Select extract(hour from (SYSTIMESTAMP-return_time)) into hours from dual;

if (SUBSTR(r_id,1,1)='B') THEN
	Select B.Reserved into res from Book B,Lib_Resource LR where B.RESOURCE_ID=LR.RESOURCE_ID and LR.RESOURCE_ID=p_resource_id;
	DELETE FROM Member_issues_resource where RESOURCE_ID=p_resource_id;
	COMMIT;
	UPDATE lib_resource set availability='Available' where resource_id=p_resource_id;   
	COMMIT; 
	if(SYSDATE >= return_time) then
		DBMS_OUTPUT.PUT_LINE('In condition SYSTIMESTAMP >= return_time');
		if(res='Yes') THEN
			INSERT into MEMBER_DUES values(p_member_id,p_resource_id,(hours+days*24)*2);
			Insert into Member_defaulter_archive values(p_member_id,p_resource_id,trunc(sysdate));
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('inserted in MEMBER_DUES');
		else
			INSERT into MEMBER_DUES values(p_member_id,p_resource_id,days*2);
			Insert into Member_defaulter_archive values(p_member_id,p_resource_id,trunc(sysdate));
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('inserted in MEMBER_DUES');
		end if;
	end if;	
end if;	

if (SUBSTR(r_id,1,1)='J') THEN        
	DELETE FROM Member_issues_resource where RESOURCE_ID=p_resource_id and member_id=p_member_id;
	COMMIT;
	UPDATE lib_resource set availability='Available' where resource_id=p_resource_id;   
	COMMIT;  
	if(SYSDATE >= return_time) then
			INSERT into MEMBER_DUES values(p_member_id,p_resource_id,(hours+days*24)*2);
			Insert into Member_defaulter_archive values(p_member_id,p_resource_id,trunc(sysdate));
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('inserted in MEMBER_DUES');
	end if;	
end if;

if (SUBSTR(r_id,1,2)='CP') THEN        
	DELETE FROM Member_issues_resource where RESOURCE_ID=p_resource_id and member_id=p_member_id;
	COMMIT;
	UPDATE lib_resource set availability='Available' where resource_id=p_resource_id;   
	COMMIT;
	if(SYSDATE >= return_time) then
			INSERT into MEMBER_DUES values(p_member_id,p_resource_id,(hours+days*24)*2);
			Insert into Member_defaulter_archive values(p_member_id,p_resource_id,trunc(sysdate));
			UPDATE Member set priority=0 where member_id=p_member_id;
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('inserted in MEMBER_DUES');
	end if;	
end if;	
COMMIT;
END RETURNING;


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- PROCEDURE TO RELEASE A ROOM

CREATE OR REPLACE PROCEDURE RELEASE_ROOM(
p_member_id IN Member.member_id%TYPE
)
AS 
is_checked_out varchar(10);
p_resource_id varchar(20);
start_time timestamp;
no_of_hours integer;
flag boolean;
BEGIN
	
flag:=true;
Select RESOURCE_ID into p_resource_id from member_reserves_room where member_id=p_member_id;
Select START_TIME into start_time from member_reserves_room where member_id=p_member_id;
Select NO_OF_HOURS into no_of_hours from member_reserves_room where member_id=p_member_id;
Select IS_CHECKED_OUT into is_checked_out from member_reserves_room where member_id=p_member_id;

if (extract(hour from SYSTIMESTAMP)> extract(hour from start_time)+1) then
	if(is_checked_out = 'F') then
		UPDATE lib_resource set availability='Available' where resource_id=p_resource_id;
		COMMIT;
		Delete from member_reserves_room where member_id=p_member_id;
		COMMIT;
		Insert into failed_room_checkin values(p_member_id, p_resource_id, start_time+(1/24));
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('ROOM CANCELLED SINCE NO ONE SHOWED UP WITHIN AN HOUR');
		flag:= false;
	end if;
end if;
if(extract(hour from SYSTIMESTAMP)>extract(hour from start_time)+no_of_hours) then
	if(flag) then
		UPDATE lib_resource set availability='Available' where resource_id=p_resource_id;
		COMMIT;
		Delete from member_reserves_room where member_id=p_member_id;
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('ROOM RESERVATION TIME UP');	
	end if;
end if;

	COMMIT;	
END RELEASE_ROOM;


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--FUNCTION TO CHECK IF THE DATE IS A FRIDAY FOR CAMERA CHECKOUT

CREATE OR REPLACE FUNCTION CHECK_FRIDAY(curr_date IN DATE)
   RETURN BOOLEAN
   IS FRI_FLAG BOOLEAN;
   CURR_DAY VARCHAR(10);
   BEGIN
      SELECT TO_CHAR(CURR_DATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') as DAY
      INTO CURR_DAY
      FROM DUAL;

      IF(CURR_DAY='FRI') THEN
        FRI_FLAG:=TRUE;
      ELSE
        FRI_FLAG:=FALSE;
      END IF;

      RETURN(FRI_FLAG);
    END CHECK_FRIDAY;
/



/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--PROCEDURE TO SEND NOTIFICATIONS FOR CAMERA ISSUE

CREATE OR REPLACE PROCEDURE CAMERA_NOTIFICATION
AS
friday_flag boolean;
curr_member_id varchar2(10);
curr_resource_id varchar2(10);
curr_hold_position integer;
p_camera_name varchar2(20);
avail varchar2(20);

CURSOR CAMERA_NOTIF IS
	SELECT * FROM HOLD_CAMERA
	WHERE REQUEST_DATE=TRUNC(SYSDATE);

BEGIN

friday_flag:=check_friday(SYSDATE);

IF(friday_flag) THEN 
	IF (sysdate > TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 8:00:00 AM', 'DD-MON-YYYY HH:MI:SS PM') and sysdate < TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 8:10:00 AM', 'DD-MON-YYYY HH:MI:SS PM')) THEN
		FOR HOLD_CAMERA_REC IN CAMERA_NOTIF
		LOOP
			curr_member_id:=HOLD_CAMERA_REC.MEMBER_ID;
			curr_resource_id:=HOLD_CAMERA_REC.resource_id;
			SELECT HOLD_POSITION INTO curr_hold_position from hold_camera where member_id=curr_member_id and resource_id=curr_resource_id and REQUEST_DATE=TRUNC(SYSDATE);
			SELECT DEVICE_MODEL INTO p_camera_name FROM DEVICE WHERE RESOURCE_ID=CURR_RESOURCE_ID;
			SELECT AVAILABILITY INTO AVAIL FROM LIB_RESOURCE WHERE RESOURCE_ID=CURR_RESOURCE_ID;
			IF(curr_hold_position=1 AND AVAIL='Available') THEN
				INSERT INTO NOTIFICATION VALUES(curr_member_id,SYSDATE,'The Camera '||p_camera_name||' is available for checkout today from 9AM-10AM');
				COMMIT;
			ELSIF(CURR_HOLD_POSITION > 1 OR AVAIL='Checked Out') THEN
				INSERT INTO NOTIFICATION VALUES(curr_member_id,SYSDATE,'The Camera '||p_camera_name||' 	sis NOT available for checkout today');
				COMMIT;
			DBMS_OUTPUT.PUT_LINE(HOLD_CAMERA_REC.MEMBER_ID);
			DBMS_OUTPUT.PUT_LINE(HOLD_CAMERA_REC.RESOURCE_ID);
			END IF;
		END LOOP;	
	ELSIF (sysdate > TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 1:00:00 AM', 'DD-MON-YYYY HH:MI:SS PM') and sysdate < TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 3:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM')) THEN
		FOR HOLD_CAMERA_REC IN CAMERA_NOTIF
		LOOP
			curr_member_id:=HOLD_CAMERA_REC.MEMBER_ID;
			curr_resource_id:=HOLD_CAMERA_REC.resource_id;
			SELECT HOLD_POSITION INTO curr_hold_position from hold_camera where member_id=curr_member_id and resource_id=curr_resource_id and REQUEST_DATE=TRUNC(SYSDATE);
			SELECT DEVICE_MODEL INTO p_camera_name FROM DEVICE WHERE RESOURCE_ID=CURR_RESOURCE_ID;
			SELECT AVAILABILITY INTO AVAIL FROM LIB_RESOURCE WHERE RESOURCE_ID=CURR_RESOURCE_ID;
			IF(curr_hold_position=1 AND AVAIL='Available') THEN
				INSERT INTO NOTIFICATION VALUES(curr_member_id,SYSDATE,'The Camera '||p_camera_name||' is now NOT available for checkout');
				COMMIT;
			ELSIF(curr_hold_position=2 AND AVAIL='Available') THEN	
				INSERT INTO NOTIFICATION VALUES(curr_member_id,SYSDATE,'The Camera '||p_camera_name||' is now available for checkout');
				COMMIT;
			END IF;
		END LOOP;
	END IF;
ELSE
	DBMS_OUTPUT.PUT_LINE('Not a friday, so notifications will not be sent');
END IF;

END CAMERA_NOTIFICATION;
/

EXEC CAMERA_NOTIFICATION


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--PROCEDURE TO CHECKOUT CAMERA ON FRIDAYS


CREATE OR REPLACE PROCEDURE CAMERA_CHECKOUT
(
p_resource_id IN HOLD_CAMERA.RESOURCE_ID%TYPE,
p_member_id IN HOLD_CAMERA.MEMBER_ID%TYPE
)
AS
p_winner_member_id varchar2(10);
p_runner_member_id varchar2(10);
friday_flag boolean;
winner_flag boolean;
runner_flag boolean;
avail varchar2(20);

BEGIN

friday_flag:=check_friday(sysdate);

if(sysdate > TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 9:00:00 AM', 'DD-MON-YYYY HH:MI:SS PM') and sysdate < TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 10:00:00 AM', 'DD-MON-YYYY HH:MI:SS PM')) THEN
	winner_flag:=true;
elsif (sysdate > TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 10:00:00 AM', 'DD-MON-YYYY HH:MI:SS PM') and sysdate < TO_TIMESTAMP(TO_CHAR(SYSDATE, 'DD-MON-YYYY') || ' 12:00:00 PM', 'DD-MON-YYYY HH:MI:SS PM')) THEN
	runner_flag:=true;
else
	winner_flag:=false;
	runner_flag:=false;
end if;

select availability into avail from lib_resource where resource_id=p_resource_id;

IF(friday_flag) THEN 

	select member_id into p_winner_member_id
	from hold_camera
	where hold_position=1 AND resource_id=p_resource_id AND request_date=trunc(sysdate+4);
	DBMS_OUTPUT.PUT_LINE(p_winner_member_id);
	
	select member_id into p_runner_member_id
	from hold_camera
	where hold_position=1 AND resource_id=p_resource_id AND request_date=trunc(sysdate+4);
	DBMS_OUTPUT.PUT_LINE(p_runner_member_id);
	
	IF(p_winner_member_id=p_member_id and winner_flag and avail='Available') THEN
		DBMS_OUTPUT.PUT_LINE('You are the winner and can check out the book');
		INSERT INTO MEMBER_ISSUES_RESOURCE VALUES(p_winner_member_id,p_resource_id,SYSDATE,1,TO_TIMESTAMP(TO_CHAR(SYSDATE+6, 'DD-MON-YYYY') || ' 6:00:00 PM', 'DD-MON-YYYY HH:MI:SS AM'));
		UPDATE LIB_RESOURCE SET AVAILABILITY='Checked Out' WHERE RESOURCE_ID=P_RESOURCE_ID;
		COMMIT;
	ELSIF(p_runner_member_id=p_member_id and runner_flag and avail='Available') THEN
		INSERT INTO MEMBER_ISSUES_RESOURCE VALUES(p_runner_member_id,p_resource_id,SYSDATE,1,TO_TIMESTAMP(TO_CHAR(SYSDATE+6, 'DD-MON-YYYY') || ' 6:00:00 PM', 'DD-MON-YYYY HH:MI:SS AM'));
		UPDATE LIB_RESOURCE SET AVAILABILITY='CHECKED Out' WHERE RESOURCE_ID=P_RESOURCE_ID;
		COMMIT;
	ELSE
		DBMS_OUTPUT.PUT_LINE('You cannot checkout this camera');
	END IF;
		
ELSE
	DBMS_OUTPUT.PUT_LINE('You cannot checkout the camera since today is not a Friday');
END IF;

END CAMERA_CHECKOUT;

/

SELECT TO_TIMESTAMP(TO_CHAR(SYSDATE+6, 'DD-MON-YYYY') || ' 6:00:00 PM', 'DD-MON-YYYY HH:MI:SS AM') FROM DUAL;

CALL CAMERA_CHECKOUT('CA1','F2');



/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
--PROCEDURE TO PLACE A REQUEST FOR A CAMERA

CREATE OR REPLACE PROCEDURE CAMERA_REQUEST(
p_resource_id IN HOLD_CAMERA.RESOURCE_ID%TYPE,
p_member_id IN HOLD_CAMERA.MEMBER_ID%TYPE,
p_request_date IN HOLD_CAMERA.REQUEST_DATE%TYPE
)
AS
p_hold_position integer;
p_camera_model varchar(30);
friday_flag boolean;
BEGIN

p_hold_position:=0;

select device_model into p_camera_model from device where resource_id=p_resource_id;

friday_flag:=check_friday(p_request_date);

IF(friday_flag) THEN 
INSERT into hold_camera(RESOURCE_ID,MEMBER_ID,REQUEST_DATE) values(p_resource_id,p_member_id,p_request_date);

COMMIT;

Select count(*) into p_hold_position from hold_camera where resource_id=p_resource_id and request_date=p_request_date;

DBMS_OUTPUT.PUT_LINE('You have been placed into hold position for Camera '||p_camera_model||' at position '||p_hold_position||' on the day '||p_request_date);


UPDATE HOLD_CAMERA SET HOLD_POSITION=P_HOLD_POSITION WHERE resource_id=p_resource_id and request_date=p_request_date AND MEMBER_ID=P_MEMBER_ID;

COMMIT;

else
    DBMS_OUTPUT.PUT_LINE('Not a Friday');
	
END IF;

END CAMERA_REQUEST;
/

CALL CAMERA_REQUEST('CA1','F2',TRUNC(SYSDATE+4));


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
--PROCEDURE TO RETURN A CAMERA BEFORE NEXT FRIDAY

CREATE OR REPLACE PROCEDURE RETURN_CAMERA(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE
)
AS
p_actual_return_date timestamp;
P_expected_return_date timestamp;
number_of_hours integer;
number_of_days integer;
fine integer;

BEGIN

p_actual_return_date:=SYSDATE;
select SCHEDULED_RETURN_TIME into p_expected_return_date from member_issues_resource where resource_id=p_resource_id AND MEMBER_ID=P_MEMBER_ID;
number_of_hours:=extract(hour from(p_actual_return_date-P_expected_return_date));
number_of_days:=extract(day from(p_actual_return_date-P_expected_return_date));
fine:=number_of_hours + (number_of_days*24);

update lib_resource set AVAILABILITY='Available' where resource_id=p_resource_id;
delete from member_issues_resource where resource_id=p_resource_id and member_id=p_member_id;

COMMIT;

IF(number_of_hours < 0 or number_of_days <0 ) THEN
	DBMS_OUTPUT.PUT_LINE('Camera has been returned on time ');
ELSE
	DBMS_OUTPUT.PUT_LINE('Camera has been delayed');
	insert into member_dues values(p_member_id,p_resource_id,fine);
	Insert into Member_defaulter_archive values(p_member_id,p_resource_id,trunc(sysdate));

	insert into notification values(p_member_id,sysdate,'You have a late penalty of $'||fine|| ' for returning the camera late');
	COMMIT;
END IF;

DBMS_OUTPUT.PUT_LINE(p_actual_return_date);

END RETURN_CAMERA;	
/

CALL RETURN_CAMERA('CA1','F2');


insert into member_issues_resource values('S1','CA1',(TO_TIMESTAMP('1-OCT-2015 09.00.00', 'DD-MON-YY HH24.MI.SS')),1,(TO_TIMESTAMP('20-OCT-2015 18.00.00', 'DD-MON-YY HH24.MI.SS')));

select (TO_TIMESTAMP('8-NOV-2015 18.00.00', 'DD-MON-YY HH24.MI.SS'))-(TO_TIMESTAMP('12-NOV-2015 10.00.00', 'DD-MON-YY HH24.MI.SS')) from dual;


(TO_TIMESTAMP('2015-11-02 0924:00:00', 'YYYY-MM-DD HH24:MI:SS'))
(TO_TIMESTAMP('2015-11-08 1824:18:00', 'YYYY-MM-DD HH24:MI:SS'))

(TO_TIMESTAMP('2-NOV-2015 09.00.00', 'DD-MON-YY HH24.MI.SS'));
(TO_TIMESTAMP('8-NOV-2015 18.00.00', 'DD-MON-YY HH24.MI.SS'));

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--PROCEDURE TO SEND NOTIFICATIONS TO MEMBERS REGARDING DUE DATES (24 hrs and 3 days before due date, and 30,60,90 days after due date)

CREATE OR REPLACE PROCEDURE NOTIFY_MEMBERS
AS
no_of_hours integer;
no_of_days integer;
p_scheduled_return_time timestamp;
p_resource_id varchar2(10);
p_member_id varchar2(10);
resource_name varchar2(40);

CURSOR COUNT_MEMBERS IS
	SELECT * FROM member_issues_resource;
	
BEGIN

FOR MEMBER_REC IN COUNT_MEMBERS
LOOP
	p_resource_id:=MEMBER_REC.resource_id;
	p_member_id:=MEMBER_REC.member_id;

	Select SCHEDULED_RETURN_TIME into p_scheduled_return_time from member_issues_resource where RESOURCE_ID=p_resource_id and member_id=p_member_id;

	IF(sysdate<p_scheduled_return_time) THEN
		no_of_hours:= extract(hour from(p_scheduled_return_time-sysdate));
		no_of_days:=extract(day from(p_scheduled_return_time-sysdate));
	ELSIF(sysdate>p_scheduled_return_time) THEN
		no_of_days:=extract(day from(p_scheduled_return_time-sysdate));
	END IF;
	
	IF(SUBSTR(p_resource_id,1,1)='B') THEN
		select title into resource_name from publication p where p.resource_id=p_resource_id;
	ELSIF(SUBSTR(p_resource_id,1,2)='CA') THEN
		select device_model into resource_name from device d where d.resource_id=p_resource_id;
	END IF;
		
	IF(no_of_hours<24) THEN
		DBMS_OUTPUT.PUT_LINE(no_of_hours);
		insert into notification values(p_member_id,sysdate,'The resource '||resource_name|| ' is due in '||no_of_hours|| 'hours');
		COMMIT;
	ELSIF (no_of_days=3) THEN
		insert into notification values(p_member_id,sysdate,'The resource '||resource_name|| ' is due in 3 days');
		COMMIT;
	ELSIF (no_of_days=30) THEN
		insert into notification values(p_member_id,sysdate,'The resource '||resource_name|| ' is overdue by 30 days');
		COMMIT;
	ELSIF (no_of_days=60) THEN
		insert into notification values(p_member_id,sysdate,'The resource '||resource_name|| ' is overdue by 60 days');
		COMMIT;
	ELSIF (no_of_days>=90) THEN
		insert into notification values(p_member_id,sysdate,'The resource '||resource_name|| ' is overdue by 90 days. Your account is suspended ');
		update member m set priority=0 where m.member_id=p_member_id;
		COMMIT;
	end if;
END LOOP;

COMMIT;

END NOTIFY_MEMBERS;
/

insert into member_issues_resource values('S1','B4',sysdate-10,2,sysdate-4);


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
--PROCEDURE TO CLEAR OUTSTANDING DUES 

CREATE OR REPLACE PROCEDURE CLEAR_FINE
(
p_member_id IN HOLD_CAMERA.MEMBER_ID%TYPE
)
AS
total_fine integer;

BEGIN

SELECT sum(fine_amount) INTO total_fine 
FROM member_dues 
WHERE member_id=p_member_id;

INSERT INTO COLLECTED_FINE VALUES (HOLD_CAMERA.MEMBER_ID,total_fine,TRUNC(SYSDATE));

DELETE FROM MEMBER_DUES WHERE MEMBER_ID=P_MEMBER_ID;

COMMIT;

END



/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- PROCEDURE TO RESERVE A ROOM

CREATE OR REPLACE PROCEDURE RESERVE_ROOMS(
p_resource_id IN lib_resource.resource_id%TYPE,
p_member_id IN Member.member_id%TYPE,
p_no_of_hours IN Member_reserves_room.no_of_hours%TYPE
)
AS r_id varchar(20);
avail varchar(20);
type1 varchar(20);
p_start_time timestamp;
room_no varchar(20);
count_room integer;
capacity integer;
BEGIN

Select RESOURCE_ID into r_id from lib_resource where resource_id=p_resource_id;
Select availability into avail from lib_resource where resource_id=p_resource_id;
Select CATEGORY into type1 from ROOM where resource_id=p_resource_id;
Select CAPACITY into capacity from ROOM where resource_id=p_resource_id;

Select SYSTIMESTAMP into p_start_time from dual;
Select ROOM_NUMBER into room_no from ROOM where resource_id=p_resource_id;
Select Count(*) into count_room from member_reserves_room where member_id=p_member_id;

if(count_room=0) then
	if (avail='Available') THEN
		if(type1='Conference Room') THEN
			if(SUBSTR(p_member_id,1,1)='F') THEN
				UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;
				INSERT into MEMBER_RESERVES_ROOM values(p_member_id,p_resource_id,p_start_time,'F',p_no_of_hours);
				INSERT into Room_reserve_history values(p_resource_id,p_member_id,trunc(sysdate),capacity);
				INSERT into notification values(p_member_id,sysdate,'You have issued room  '||room_no||' for '||p_no_of_hours||' hours from '||p_start_time);
				COMMIT;
				DBMS_OUTPUT.PUT_LINE('BOOKED ROOM '||p_resource_id||' FOR '||p_no_of_hours||' HOURS');	
			else
				DBMS_OUTPUT.PUT_LINE('YOU CANNOT RESERVE CONFERENCE ROOM');
			end if;
			
		else
			UPDATE lib_resource set availability='Checked Out' where resource_id=p_resource_id;
			INSERT into MEMBER_RESERVES_ROOM values(p_member_id,p_resource_id,p_start_time,'F',p_no_of_hours);
			INSERT into Room_reserve_history values(p_resource_id,p_member_id,trunc(sysdate),capacity);
			INSERT into notification values(p_member_id,sysdate,'You have issued room: '||room_no);
				COMMIT;
			DBMS_OUTPUT.PUT_LINE('BOOKED ROOM '||p_resource_id||' FOR '||p_no_of_hours||' HOURS');		
		end if;
	else
			INSERT into Room_reserve_history values(p_resource_id,p_member_id,trunc(sysdate),capacity);
				DBMS_OUTPUT.PUT_LINE('NOT AVAILABLE');	
	END IF;  
else
			INSERT into Room_reserve_history values(p_resource_id,p_member_id,trunc(sysdate),capacity);
				DBMS_OUTPUT.PUT_LINE('You already have a room reserved');	
end if;
COMMIT;
END RESERVE_ROOMS;


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--SAMPLE QUERIES

--(Q.1) Failed to return a resource

CREATE OR REPLACE PROCEDURE Defaulted_Returns(
START_DATE Member_defaulter_archive.Return_date%TYPE,
END_DATE Member_defaulter_archive.Return_date%TYPE
)
AS
p_fname varchar(40);
p_lname varchar(40);
CURSOR defaulted_returns IS
	select member_id,count(*) as counter from member_defaulter_archive where return_date>=start_date and return_date<=end_date group by member_id order by counter DESC;
BEGIN
FOR rec in defaulted_returns
LOOP
	select fname,lname into p_fname,p_lname from member where member_id=rec.member_id;
	DBMS_OUTPUT.PUT_LINE(p_fname||' '||p_lname||','||rec.counter);
END LOOP;
End defaulted_returns;
/



/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/


--(Q.2) TOTAL NULL AND VOID ROOM RESERVES IN A GIVEN TIME PERIOD

CREATE OR REPLACE PROCEDURE Void_reservation_count(
START_DATE room_reserve_history.Reserve_date%TYPE,
END_DATE room_reserve_history.Reserve_date%TYPE
)
AS
total int;
BEGIN
Select count(*) into total from failed_room_checkin;
DBMS_OUTPUT.PUT_LINE(total);
End Void_reservation_count;
/

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--(Q.3) DETERMING THE FINE COLLECTED BETWEEN TWO DATES


CREATE OR REPLACE PROCEDURE FINE_CALCULATOR
(
START_DATE COLLECTED_FINE.COLLECTED_DATE%TYPE,
END_DATE COLLECTED_FINE.COLLECTED_DATE%TYPE
)
AS
total_fine integer;

BEGIN

SELECT sum(fine_amount) INTO total_fine 
FROM collected_fine 
WHERE collected_date >= START_DATE AND collected_date<=END_DATE;

COMMIT;

DBMS_OUTPUT.PUT_LINE('Total Collected fine for the period between '|| START_DATE || ' and ' || END_DATE || ' is $' ||total_fine);

END FINE_CALCULATOR;
/

EXEC FINE_CALCULATOR('5-NOV-2015','5-DEC-2015');

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/

--(Q.4) HIGHEST DEMAND ROOMS

CREATE OR REPLACE PROCEDURE Highest_demand_rooms(
START_DATE room_reserve_history.Reserve_date%TYPE,
END_DATE room_reserve_history.Reserve_date%TYPE
)
AS
CURSOR reserved_rooms IS
	select capacity,count(*) as counter from room_reserve_history where reserve_date>=start_date and reserve_date<=end_date group by capacity order by counter DESC;

BEGIN
DBMS_OUTPUT.PUT_LINE('CAP,COUNT');
FOR rec in reserved_rooms
LOOP
	DBMS_OUTPUT.PUT_LINE(rec.capacity||','||rec.counter);
END LOOP;
End Highest_demand_rooms;
/

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- TRIGGER TO DISALLOW INVALID DEGREE COMBINATION ENTRIES INTO THE STUDENT TABLE (eg. Bachelors in a Doctorate program)


CREATE or REPLACE TRIGGER check_student_is_valid
Before INSERT or UPDATE on student
for each row
BEGIN
if  :new.stud_class='Undergraduate' and :new.degree_pgm='PhD' or  :new.degree_pgm='MS' then
RAISE_APPLICATION_ERROR( 20001,'An Undergraduate cannot pursue MS or PhD');
end if;
end;
/


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- TRIGGER TO DISALLOW A CONFERENCE ROOM ENTRY IN D.H.Hill

CREATE Or REPLACE TRIGGER check_room_type
Before INSERT or UPDATE on room
for each row
DECLARE 
t_lib_id varchar2(20);
BEGIN
    Select LR.Lib_id into t_lib_id from Library L, Lib_Resource LR where LR.Lib_id=L.Lib_id and LR.Resource_id =:new.resource_id ;
        if t_lib_id='L1' and :new.category='Conference Room' then
                RAISE_APPLICATION_ERROR(-20001, 'D.H Hill cannot have a conference room');
        end if;
end;
/


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- TRIGGER TO RESTRICT ROOM RESERVATION PERIOD TO 3 HOURS

CREATE or REPLACE TRIGGER check_room_duration_is_valid
Before INSERT or UPDATE on member_reserves_room
for each row
BEGIN
if  :new.no_of_hours>3 then
RAISE_APPLICATION_ERROR( 20001,'Cannot reserve a room for more than 3 hours');
end if;
end;
/

