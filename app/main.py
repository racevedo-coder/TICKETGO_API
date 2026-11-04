from fastapi import FastAPI
from app.routes import reportes, analitica

app = FastAPI(title="TicketGo API")
app.include_router(reportes.router)
app.include_router(analitica.router)
