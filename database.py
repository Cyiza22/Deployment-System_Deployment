from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Create SQLite database file
DATABASE_URL = "sqlite:///./students.db"

# If using PostgreSQL on Render, use:
# DATABASE_URL = "postgresql://user:password@hostname:port/dbname"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
