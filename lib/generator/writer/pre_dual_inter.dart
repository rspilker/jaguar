part of jaguar.generator.writer;

class InterceptorClassPreWriter {
  final RouteInfo route;

  final InterceptorClassInfo info;

  InterceptorClassPreWriter(this.route, this.info);

  String generate() {
    StringBuffer sb = new StringBuffer();

    InterceptorFuncDef pre = info.dual.pre;

    if (route.isDualInterceptorResultUsed(info)) {
      if (!info.result.isVoid) {
        if (!info.result.isDartAsyncFuture) {
          sb.write(info.result.toString() + " ");
          sb.write(info.genReturnVarName + " = ");
        } else {
          sb.write(info.returnsFutureFlattened.toString() + " ");
          sb.write(info.genReturnVarName + " = await ");
        }
      }
    } else {
      if (!info.result.isVoid) {
        if (info.result.isDartAsyncFuture) {
          sb.write("await ");
        }
      }
    }

    sb.write(info.genInstanceName);
    sb.write(".pre(");

    if (pre.needsHttpRequest) {
      sb.write("request, ");
    }

    if (pre.inputs.length != 0) {
      final String params =
          pre.inputs.map((InputInfo info) => info.genName).join(", ");
      sb.write(params);
      sb.write(',');
    }

    if (pre.nonInputParams.length > 0) {
      final String paramsStr = pre.nonInputParams
          .map((ParameterElement param) => new ParameterElementWrap(param))
          .map((ParameterElementWrap param) {
        if (param.name == 'pathParams') {
          return 'pathParams';
        } else if (param.name == 'queryParams') {
          return 'queryParams';
        }
        return 'null';
      }).join(',');

      sb.write(paramsStr);
      sb.write(',');
    }

    sb.writeln(");");

    return sb.toString();
  }
}
