FROM python:3.10 AS build

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install -U pip \
  && pip install -U wheel \
  && pip install --extra-index-url https://download.pytorch.org/whl/cu117 \
    torch==1.13.1 \
    torchvision \
    torchaudio \
  && pip install xformers

COPY ComfyUI/requirements.txt .

RUN pip install -U pip \
  && pip install -U wheel \
  && pip install -r requirements.txt

FROM python:3.10 AS run

ENV VIRTUAL_ENV=/opt/venv
COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

EXPOSE 8188

COPY ComfyUI /usr/local/ComfyUI
ENTRYPOINT [ "python", "/usr/local/ComfyUI/main.py", "--listen" ]
