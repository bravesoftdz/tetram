object dwsBackgroundWorkersLib: TdwsBackgroundWorkersLib
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 695
  Top = 86
  Height = 129
  Width = 220
  object dwsBackgroundWorkers: TdwsUnit
    Classes = <
      item
        Name = 'BackgroundWorkers'
        IsStatic = True
        Methods = <
          item
            Name = 'CreateWorkQueue'
            Parameters = <
              item
                Name = 'name'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            Attributes = [maStatic]
            OnEval = dwsBackgroundWorkersClassesBackgroundWorkersMethodsCreateWorkQueueEval
            Kind = mkClassFunction
          end
          item
            Name = 'DestroyWorkQueue'
            Parameters = <
              item
                Name = 'name'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            Attributes = [maStatic]
            OnEval = dwsBackgroundWorkersClassesBackgroundWorkersMethodsDestroyWorkQueueEval
            Kind = mkClassFunction
          end
          item
            Name = 'QueueWork'
            Parameters = <
              item
                Name = 'name'
                DataType = 'String'
              end
              item
                Name = 'task'
                DataType = 'String'
              end
              item
                Name = 'data'
                DataType = 'String'
                HasDefaultValue = True
                DefaultValue = ''
              end>
            Attributes = [maStatic]
            OnEval = dwsBackgroundWorkersClassesBackgroundWorkersMethodsQueueWorkEval
            Kind = mkClassProcedure
          end
          item
            Name = 'QueueSize'
            Parameters = <
              item
                Name = 'name'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            Attributes = [maStatic]
            OnEval = dwsBackgroundWorkersClassesBackgroundWorkersMethodsQueueSizeEval
            Kind = mkClassFunction
          end>
      end>
    UnitName = 'System.Workers'
    StaticSymbols = False
    Left = 80
    Top = 16
  end
end
