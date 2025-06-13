from fastapi import FastAPI
from middleware import auth_middleware
from models.base import Base
from routes import auth, song
from database import engine



app = FastAPI()
app.include_router(auth.router , prefix='/auth')
app.include_router(song.router, prefix='/song')



#we interact with this to the database

Base.metadata.create_all(engine)
