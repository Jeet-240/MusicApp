from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary
from models.base import Base


class User(Base):
    __tablename__ = 'users'

    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(256))
    email =  Column(VARCHAR(256))
    password = Column(LargeBinary)
