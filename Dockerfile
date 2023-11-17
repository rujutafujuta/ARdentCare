# Install dependencies
FROM python:3.10 AS basic-install-dependencies

RUN git clone https://github.com/s0md3v/roop
WORKDIR /roop
RUN git checkout 4867f356ef4d40e659b4ee476043d4fa4c6cad28

RUN apt-get update
RUN apt-get install -y ffmpeg

RUN pip3 cache purge
RUN pip3 install -r requirements.txt

# Copy files
FROM basic-install-dependencies AS basic-copy-files
#create directory for insight face
RUN mkdir -p /root/.insightface/models
# get the inswapper_128.onnx model
RUN wget --no-check-certificate "https://drive.google.com/file/d/1YkCMYad_hIeNen5ZVAVzD7-Gu_Er6-kA/view?usp=sharing" -O /root/.insightface/models/inswapper_128.onnx
#get the buffalo_l model from insightface
RUN wget -O buffalo_l.zip https://github.com/deepinsight/insightface/releases/download/v0.7/buffalo_l.zip
RUN unzip buffalo_l.zip -d /root/.insightface/models/buffalo_l

# Move back to the original working directory
WORKDIR /

EXPOSE 8080

# Basic installation
FROM basic-copy-files AS basic-version

# Basic run
FROM basic-version AS roop
ENTRYPOINT ["python", "run.py"]
