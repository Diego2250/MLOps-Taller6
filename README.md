# 🚀 Taller 6 – Terraform + Docker

Este laboratorio implementa una arquitectura de datos utilizando *Terraform* para orquestar contenedores Docker. Se diseñó la separación entre procesos de *Ingeniería de Datos (ETL)* y procesos de *Ciencia de Datos (ML API)*.  

- Javier Azurdia
- Angel Castellanos
- Sara Echeverría
- Diego Morales
- Enlace al repositorio: https://github.com/Diego2250/MLOps-Taller6
---

## 📌 1. Documentación consultada
- [Terraform Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)  
- [Documentación oficial de Docker](https://docs.docker.com/)  

---

## 📌 2. Arquitectura de Datos

El sistema está compuesto por *dos contenedores*:

### 🔹 ETL – Ingeniería de Datos
- *Contenedor:* etl-pipeline  
- *Dockerfile:* Dockerfile.pipeline  
- *Código:* pipeline.py  
- *Función:* 
  - Cargar dataset.
  - Limpiar y transformar datos.
  - Entrenar modelo (scikit-learn).
  - Guardar modelo entrenado como model.joblib en /data.

### 🔹 ML API – Ciencia de Datos
- *Contenedor:* ml-api  
- *Dockerfile:* Dockerfile  
- *Código:* src/pipeline/app.py con *FastAPI*.  
- *Función:* 
  - Cargar model.joblib desde volumen compartido.
  - Exponer endpoints:
    - GET / → healthcheck.  
    - POST /predict → recibe features en JSON y devuelve predicción.

---

## 📌 3. Infraestructura como Código (IaC)

La infraestructura se define en main.tf con el provider Docker.  
Ejemplo de despliegue:

```bash
terraform init
terraform apply -auto-approve
```

Esto crea automáticamente:
	•	Imagen + contenedor de ETL.
	•	Imagen + contenedor de la API ML.
	•	Volumen compartido para persistir el modelo.

⸻

📌 4. Compartir imágenes Docker sin Docker Hub

Para exportar e importar imágenes sin un registry:

# Guardar imagen en archivo tar
docker save -o ml_app.tar ml_app:latest
docker save -o etl_app.tar etl_app:latest

# Copiar archivo a otra máquina y cargarlo
```bash
docker load -i ml_app.tar
docker load -i etl_app.tar
```


⸻

📌 5. Evidencias

Terraform apply

Captura del despliegue exitoso.

Contenedores creados

docker ps -a

API corriendo

Acceso a http://localhost:8080/docs

Predicción de ejemplo

Request

POST /predict
{
  "sepal length (cm)": 5.1,
  "sepal width (cm)": 3.5,
  "petal length (cm)": 1.4,
  "petal width (cm)": 0.2
}

Response

{
  "prediction": 0
}


⸻

📌 6. Conclusiones
	1.	Infraestructura como Código (IaC): permite levantar entornos reproducibles y portables con un solo comando (terraform apply).
	2.	Separación de roles: se evidenció la diferencia entre procesos de ETL y de API de predicciones, lo cual refleja arquitecturas reales en MLOps.
	3.	Portabilidad de modelos: el uso de volúmenes y exportación de imágenes (docker save/load) facilita compartir soluciones sin necesidad de un registry.
	4.	Escalabilidad: esta misma arquitectura puede ser llevada a Kubernetes o la nube para ambientes productivos.

⸻

📌 7. Estructura del repo

├── docker/
│   ├── Dockerfile          # ML API
│   ├── Dockerfile.pipeline # ETL
│   ├── requirements.txt
│   ├── data/
│   │   └── model.joblib    # modelo entrenado
│   └── src/pipeline/
│       ├── app.py          # FastAPI
│       └── pipeline.py     # Entrenamiento
├── terraform/
│   └── main.tf
└── README.md
