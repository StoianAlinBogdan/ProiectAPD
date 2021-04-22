classdef APD < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        EXITButton                     matlab.ui.control.Button
        ClearPlotsButton               matlab.ui.control.Button
        InterpolareDropDown            matlab.ui.control.DropDown
        InterpolareDropDownLabel       matlab.ui.control.Label
        PlotReconstructionButton       matlab.ui.control.Button
        PlotSamplesButton              matlab.ui.control.Button
        PlotFunctionButton             matlab.ui.control.Button
        FrecventaEsantionareEditField  matlab.ui.control.NumericEditField
        FrecventaEsantionareEditFieldLabel  matlab.ui.control.Label
        IntervaldeTimpEditField        matlab.ui.control.NumericEditField
        IntervaldeTimpEditFieldLabel   matlab.ui.control.Label
        FunctiaDropDown                matlab.ui.control.DropDown
        FunctiaDropDownLabel           matlab.ui.control.Label
        Esantioane                     matlab.ui.control.UIAxes
        Functia                        matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: PlotFunctionButton
        function PlotFunctionButtonPushed(app, event)
            limita = app.IntervaldeTimpEditField.Value;
            t = 0:0.01:limita;
            if strcmp(app.FunctiaDropDown.Value, 'sin(t)')
                y = sin(2 * t);
                plot(app.Functia, t, y, "r");
            else
                y = 1.5 * cos(1.5*t) - 0.15 * cos(0.5*t);
                plot(app.Functia, t, y, "r");
            end
        end

        % Button pushed function: PlotSamplesButton
        function PlotSamplesButtonPushed(app, event)
        limita = app.IntervaldeTimpEditField.Value;
        frecventa = app.FrecventaEsantionareEditField.Value;
        t = 0:frecventa:limita;
        if strcmp(app.FunctiaDropDown.Value, 'sin(t)')
            y = sin(2 * t);
            plot(app.Esantioane, t, y, "*b");
            hold(app.Esantioane, 'on');
        else
            y = 1.5 * cos(1.5*t) - 0.15 * cos(0.5*t);
            plot(app.Esantioane, t, y, "*b");
            hold(app.Esantioane, 'on');
        end

        
        end

        % Button pushed function: PlotReconstructionButton
        function PlotReconstructionButtonPushed(app, event)
        limita = app.IntervaldeTimpEditField.Value;
        frecventa = app.FrecventaEsantionareEditField.Value;
        t = 0:frecventa:limita;
        if strcmp(app.FunctiaDropDown.Value, 'sin(t)')
            y = sin(2 * t);
            if strcmp(app.InterpolareDropDown.Value, 'Lagrange')
                interpol = 0:frecventa:limita;
                n = size(t, 2);
                L = ones(n, size(interpol, 2));
                for i = 1:n
                    for j = 1:n
                        if i~=j
                            L(i,:) = L(i,:) .* (interpol - t(j)) / (t(i) - t(j));
                        end
                    end
                end
                yy = 0;
                for i = 1:n
                    yy = yy + y(i) * L(i,:);
                end
                plot(app.Esantioane, t, yy, "g");
                hold(app.Esantioane, 'on');
            else
                xx = 0:frecventa:limita;
                yyy = spline(t, y, xx);
                plot(app.Esantioane, xx, yyy, "c");
                hold(app.Esantioane, 'on');
            end
        else
           y = 1.5 * cos(1.5*t) - 0.15 * cos(0.5*t);
           if strcmp(app.InterpolareDropDown.Value, 'Lagrange')
                interpol = 0:frecventa:limita;
                n = size(t, 2);
                L = ones(n, size(interpol, 2));
                for i = 1:n
                    for j = 1:n
                        if i~=j
                            L(i,:) = L(i,:) .* (interpol - t(j)) / (t(i) - t(j));
                        end
                    end
                end
                yy = 0;
                for i = 1:n
                    yy = yy + y(i) * L(i,:);
                end
                plot(app.Esantioane, t, yy, "g");
                hold(app.Esantioane, 'on');
            else
                xx = 0:frecventa:limita;
                yyy = spline(t, y, xx);
                plot(app.Esantioane, xx, yyy, "c");
                hold(app.Esantioane, 'on');
            end
        end

            
        end

        % Button pushed function: ClearPlotsButton
        function ClearPlotsButtonPushed(app, event)
            cla(app.Functia);
            cla(app.Esantioane);
        end

        % Button pushed function: EXITButton
        function EXITButtonPushed(app, event)
            closereq;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 745 487];
            app.UIFigure.Name = 'MATLAB App';

            % Create Functia
            app.Functia = uiaxes(app.UIFigure);
            title(app.Functia, 'Functia')
            xlabel(app.Functia, 't')
            ylabel(app.Functia, 'f(t)')
            zlabel(app.Functia, 'Z')
            app.Functia.Position = [396 233 331 231];

            % Create Esantioane
            app.Esantioane = uiaxes(app.UIFigure);
            title(app.Esantioane, 'esantioane + reconstructie')
            xlabel(app.Esantioane, 't')
            ylabel(app.Esantioane, 'Y')
            zlabel(app.Esantioane, 'Z')
            app.Esantioane.Position = [397 1 331 207];

            % Create FunctiaDropDownLabel
            app.FunctiaDropDownLabel = uilabel(app.UIFigure);
            app.FunctiaDropDownLabel.HorizontalAlignment = 'right';
            app.FunctiaDropDownLabel.Position = [1 466 45 22];
            app.FunctiaDropDownLabel.Text = 'Functia';

            % Create FunctiaDropDown
            app.FunctiaDropDown = uidropdown(app.UIFigure);
            app.FunctiaDropDown.Items = {'sin(t)', '1.5 * cos(1.5*t) - 0.15 * cos(0.5*t)'};
            app.FunctiaDropDown.Position = [61 466 193 22];
            app.FunctiaDropDown.Value = 'sin(t)';

            % Create IntervaldeTimpEditFieldLabel
            app.IntervaldeTimpEditFieldLabel = uilabel(app.UIFigure);
            app.IntervaldeTimpEditFieldLabel.HorizontalAlignment = 'right';
            app.IntervaldeTimpEditFieldLabel.Position = [1 424 91 22];
            app.IntervaldeTimpEditFieldLabel.Text = 'Interval de Timp';

            % Create IntervaldeTimpEditField
            app.IntervaldeTimpEditField = uieditfield(app.UIFigure, 'numeric');
            app.IntervaldeTimpEditField.Position = [107 424 147 22];

            % Create FrecventaEsantionareEditFieldLabel
            app.FrecventaEsantionareEditFieldLabel = uilabel(app.UIFigure);
            app.FrecventaEsantionareEditFieldLabel.HorizontalAlignment = 'right';
            app.FrecventaEsantionareEditFieldLabel.Position = [1 388 126 22];
            app.FrecventaEsantionareEditFieldLabel.Text = 'Frecventa Esantionare';

            % Create FrecventaEsantionareEditField
            app.FrecventaEsantionareEditField = uieditfield(app.UIFigure, 'numeric');
            app.FrecventaEsantionareEditField.Position = [142 388 112 22];

            % Create PlotFunctionButton
            app.PlotFunctionButton = uibutton(app.UIFigure, 'push');
            app.PlotFunctionButton.ButtonPushedFcn = createCallbackFcn(app, @PlotFunctionButtonPushed, true);
            app.PlotFunctionButton.Position = [2 309 115 22];
            app.PlotFunctionButton.Text = 'PlotFunction';

            % Create PlotSamplesButton
            app.PlotSamplesButton = uibutton(app.UIFigure, 'push');
            app.PlotSamplesButton.ButtonPushedFcn = createCallbackFcn(app, @PlotSamplesButtonPushed, true);
            app.PlotSamplesButton.Position = [1 274 116 22];
            app.PlotSamplesButton.Text = 'PlotSamples';

            % Create PlotReconstructionButton
            app.PlotReconstructionButton = uibutton(app.UIFigure, 'push');
            app.PlotReconstructionButton.ButtonPushedFcn = createCallbackFcn(app, @PlotReconstructionButtonPushed, true);
            app.PlotReconstructionButton.Position = [1 233 116 22];
            app.PlotReconstructionButton.Text = 'PlotReconstruction';

            % Create InterpolareDropDownLabel
            app.InterpolareDropDownLabel = uilabel(app.UIFigure);
            app.InterpolareDropDownLabel.HorizontalAlignment = 'right';
            app.InterpolareDropDownLabel.Position = [5 352 63 22];
            app.InterpolareDropDownLabel.Text = 'Interpolare';

            % Create InterpolareDropDown
            app.InterpolareDropDown = uidropdown(app.UIFigure);
            app.InterpolareDropDown.Items = {'Lagrange', 'Spline'};
            app.InterpolareDropDown.Position = [83 352 100 22];
            app.InterpolareDropDown.Value = 'Lagrange';

            % Create ClearPlotsButton
            app.ClearPlotsButton = uibutton(app.UIFigure, 'push');
            app.ClearPlotsButton.ButtonPushedFcn = createCallbackFcn(app, @ClearPlotsButtonPushed, true);
            app.ClearPlotsButton.Position = [2 186 100 22];
            app.ClearPlotsButton.Text = 'ClearPlots';

            % Create EXITButton
            app.EXITButton = uibutton(app.UIFigure, 'push');
            app.EXITButton.ButtonPushedFcn = createCallbackFcn(app, @EXITButtonPushed, true);
            app.EXITButton.Position = [6 53 206 39];
            app.EXITButton.Text = 'EXIT';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = APD

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end