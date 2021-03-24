FROM hashicorp/terraform:0.14.8
RUN mkdir /keys
RUN mkdir /api
RUN mkdir /react
RUN chmod -R 400 /keys