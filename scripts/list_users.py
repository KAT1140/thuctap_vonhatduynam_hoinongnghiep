from app import get_db_connection
conn = get_db_connection()
if not conn:
    print('NO_CONN')
else:
    cur = conn.cursor()
    cur.execute("SELECT id,username,role,full_name FROM users LIMIT 50")
    rows = cur.fetchall()
    if not rows:
        print('NO_USERS')
    else:
        for r in rows:
            print(r)
    cur.close()
    conn.close()
