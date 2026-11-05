from fastapi import FastAPI
from app.routes import reportes, analitica, items, segmentos

app = FastAPI(title="TicketGo API")
app.include_router(reportes.router)
app.include_router(analitica.router)
app.include_router(items.router)
app.include_router(segmentos.router)