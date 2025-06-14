from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


DATABASE_URL = 'postgresql://postgres:202301017@localhost:5432/fluttermusicapp'


engine = create_engine(DATABASE_URL)
#engine is the central point of connection to out database

SessionLocal = sessionmaker(autocommit = False, autoflush=False, bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
